<script lang="coffee">
import OpenSeadragon from 'openseadragon'
import SVGOverlay from '../lib/openseadragon-svg-overlay.js'
import ZoomifyTileSource from '../lib/zoomifytilesource.js'
import ZoomableImageOverlay from './ZoomableImageOverlay.vue'
import SpaceSwitch from './SpaceSwitch.vue'
import config from './config.coffee'
import Vue from 'vue'
import * as d3 from 'd3'

export default {

  render: (createElement) ->
    elements = []

    if @fullscreen
      # Space switch
      elements.push createElement 'spaceswitch', {}

      # Zoom controls +/-
      elements.push createElement 'div', {
        class: 'zoom_control'
      }, [
        createElement('div', {}, [
          createElement 'button', {
            attrs:
              id: 'openseadragon_zoom_in_control'
              class: 'in'
            }, [
              createElement 'i', {class: 'icon-plus'}
            ]
          ]
        ),
        createElement('div', {}, [
          createElement 'button', {
            attrs:
              id: 'openseadragon_zoom_out_control'
              class: 'out'
            }, [
              createElement 'i', {class: 'icon-minus'}
            ]
          ]
        )
      ]

      # Show/hide annotations
      elements.push createElement 'div', {
        class: 'annotation_control'
      }, [
        createElement('button', {
          on:
            click: () => @annotation_visible = not @annotation_visible
          }, [
            createElement 'i', {
              'class': if @annotation_visible then 'icon-hide' else 'icon-show'
            }
          ])
      ]

    if @fullscreen and @space.geo_bounds?
      # Opacity slider
      elements.push createElement 'div', {
        class: 'opacity_control'
      }, [
        createElement 'input', {
          class: 'slider'
          attrs:
            type: 'range'
            step: '1'
            min: '0'
            max: '10'
            value: '10'
          on:
            '~mouseover': () => @register_opacity_changes()
        }
      ]

    if @fullscreen and @closeable
      # Top right X close button
      elements.push createElement 'button', {
        class: 'close_button'
        on:
          'click': (event) => 
            event.stopPropagation()
            @$emit('close')
      }, [
        createElement 'i', {
          class: 'icon-x'
        }
      ]

    # SVG Overlay
    if @svg_overlay?
      OverlayComponent = Vue.extend(ZoomableImageOverlay)
      overlay_component = new OverlayComponent
        data:
          nodes: @converted_nodes
          store: @$store
          viewer: @viewer
          annotations: @annotations
      overlay_component.$mount()
      @$el.querySelector('svg g').appendChild(overlay_component.$el)
      
      # Add CSS mix blend mode style
      @$el.querySelector('svg').style['mix-blend-mode'] = 'multiply'
      
      @show_hide()

    # Overall "template"
    return createElement 'div', {
      attrs:
        id: "zoomableimageview"
      'class':
        fullscreen: @fullscreen
        zoom_cursor: not @fullscreen
      style:
        background: @background
      on:
        'keyup': (event) =>
          if event.key is 'Escape'
            event.stopPropagation()
            @$emit('close')
    }, elements

  data: () ->
    initial_pan: undefined
    initial_zoom: undefined
    annotation_visible: true
    svg_overlay: undefined
    mercator: d3.geoMercator()
      .translate [0.5, 0.5]
      .scale 1/(2*Math.PI)

  props:
    fullscreen:
      type: Boolean
      'default': true
    closeable:
      type: Boolean
      'default': false

  computed:
    space: () -> @$store.state.selection.space
    annotations: () -> if @space.annotations? then JSON.parse(@space.annotations) else {}
    background: () -> if @space.background_color? then @space.background_color else 'black'
  
  watch:
    space: (newSpace) -> @load_map()
    fullscreen: (n, o) -> @refresh(n, o)
    annotation_visible: () -> @show_hide()

  mounted: () ->
    # Compute tilesources through config template according to data
    tilesources = JSON.parse(@space.tile_source).map (ts) -> config.openseadragon_templates[ts.type](ts)

    # override global config with space config
    openseadragon = {}
    Object.assign openseadragon, config.openseadragon
    if @space.openseadragon?
      Object.assign openseadragon, JSON.parse @space.openseadragon

    # OpenSeadragon viewer creation
    openseadragon.tileSources = tilesources
    @viewer = OpenSeadragon openseadragon

    # Remove default zoom controls
    if not (openseadragon.zoomInButton? and openseadragon.zoomOutButton?)
      @viewer.controls[0].destroy()

    # Set margins according to infobox
    @viewer.viewport.setMargins({left: 20, right: 20, top: 0, bottom: 0})

    @load_map()
    @refresh(@fullscreen)

  methods:
    refresh: (new_value, old_value) ->
      # go to fullscreen
      if not old_value and new_value
        @viewer.setMouseNavEnabled true
        @annotation_visible = true

      # exit fullscreen
      else if old_value and not new_value
        @viewer.setMouseNavEnabled false

        # set initial view
        if @space.geo_bounds?
          @change_opacity 1
          @fit_bounds()
        else
          @viewer.viewport.goHome true

      @show_hide()

    show_hide: () -> 
      svg = @$el.querySelector('svg')
      if svg?
        svg.style['display'] = if @fullscreen and @annotation_visible then 'inline' else 'none'

    fit_bounds: () ->
      min = @mercator([@space.geo_bounds[1], @space.geo_bounds[0]])
      max = @mercator([@space.geo_bounds[3], @space.geo_bounds[2]])
      @viewer.viewport.fitBounds(new OpenSeadragon.Rect(min[0], max[1], max[0]-min[0], min[1]-max[1]), true)
    
    register_opacity_changes: () ->
      # When there is a gdal2tiles image register oninput event for opacity changes
      if @space.geo_bounds?
        _this = @
        document.querySelector('.slider').oninput = (e) ->
          _this.change_opacity this.value/10

    change_opacity: (value) ->
      @viewer.world.getItemAt(1).setOpacity value

    load_map: () ->
      new_zoom = @initial_zoom
      new_pan = @initial_pan

      if @viewer.isOpen()
        @viewer.open(@space.tile_source)

      ### Store every zoom & pan change
      ###
      @viewer.addHandler 'pan', (event) =>
        @initial_pan = event.center
      @viewer.addHandler 'zoom', (event) =>
        @initial_zoom = event.zoom

      @viewer.addHandler 'open', (event) =>
        ### Fit an initial bounding box in the case of geo tiles
        ###
        if @space.geo_bounds?
          @fit_bounds()

        ### Restore the zoom & pan of the previous space
        ###
        if new_pan?
          @viewer.viewport.panTo(new_pan, true)
        if new_zoom?
          @viewer.viewport.zoomTo(new_zoom, true)

        ### Image to viewport coordinates conversion
        ###
        if not @converted_nodes? or @converted_nodes.length is 0
          @converted_nodes = @space.nodes.map (d) => 
            if d.data.x1? and d.data.y1?
              p = @viewer.viewport.imageToViewportCoordinates d.data.x1, d.data.y1
              d.data.x1 = p.x
              d.data.y1 = p.y
            if d.data.x2? and d.data.y2?
              p = @viewer.viewport.imageToViewportCoordinates d.data.x2, d.data.y2
              d.data.x2 = p.x
              d.data.y2 = p.y
            if d.data.cx? and d.data.cy?
              p = @viewer.viewport.imageToViewportCoordinates d.data.cx, d.data.cy
              d.data.cx = p.x
              d.data.cy = p.y
              d.data.rx = @viewer.viewport.imageToViewportCoordinates(d.data.rx).x
            if d.data.points?
              d.data.points = JSON.parse(d.data.points).map((path) => path.map((p) => @viewer.viewport.imageToViewportCoordinates p.x, p.y))
            return d

        ### SVG overlay creation
        ###
        @svg_overlay = @viewer.svgOverlay()

      ### Console points
      ###
#      @viewer.addHandler 'canvas-click', (event) =>
#        # The canvas-click event gives us a position in web coordinates.
#        webPoint = event.position;
#  
#        # Convert that to viewport coordinates, the lingua franca of OpenSeadragon coordinates.
#        viewportPoint = @viewer.viewport.pointFromPixel(webPoint);
#  
#        # Convert from viewport coordinates to image coordinates.
#        imagePoint = @viewer.viewport.viewportToImageCoordinates(viewportPoint);
#  
#        # Show the results.
#        #console.log(webPoint.toString(), viewportPoint.toString(), imagePoint.toString());
#        console.log imagePoint

  components:
    spaceswitch: SpaceSwitch
    zoomableimageoverlay: ZoomableImageOverlay

}
</script>

<style scoped>
#zoomableimageview {
  width: 92%;
  height: 100%;
  margin: auto;
  border: 1px solid #DDD;
  box-sizing: border-box;
}

.fullscreen {
  position: absolute !important;
  width: 100% !important;
  top: 0;
  left: 0;
  padding: 0;
  z-index: 4;
  border: 0 !important;
}
.zoom_cursor {
  cursor: zoom-in;
}

.zoom_control {
  position: absolute;
  bottom: 15px;
  right: 20px;
  z-index: 2;
}
.zoom_control .in, .zoom_control .out {
  width: 30px;
  height: 30px;
  background: #FFF;
  border: none;
  border-bottom: 1px solid #F2F2F2;
  box-shadow: 0px 1px 4px rgba(0,0,0,0.3);
  color: rgb(178, 178, 178);
  cursor: pointer;
}
.zoom_control .in:hover, .zoom_control .out:hover {
  color: rgb(100, 100, 100);
}
.zoom_control .in {
  border-top-right-radius: 5px;
  border-top-left-radius: 5px;
}
.zoom_control .out {
  border-bottom-right-radius: 5px;
  border-bottom-left-radius: 5px;
}

.annotation_control {
  position: absolute;
  bottom: 80px;
  right: 20px;
  z-index: 2;
}
.annotation_control button {
  width: 30px;
  height: 30px;
  background: #FFF;
  border: none;
  border-radius: 5px;
  box-shadow: 0px 1px 4px rgba(0,0,0,0.3);
  color: rgb(178, 178, 178);
  cursor: pointer;
  font-size: 14px;
}
.annotation_control button:hover {
  color: rgb(100, 100, 100);
}

.opacity_control {
  position: absolute;
  top: 10px;
  right: calc((100% - 129px) / 2);
  z-index: 2;
}

.close_button {
  position: absolute;
  top: 15px;
  right: 10px;
  background: transparent;
  border: none;
  color: #FFF;
  text-shadow: #000 0px 0px 6px;
  font-size: 15px;
  cursor: pointer;
  z-index: 1;
}
</style>
<style>
#zoomableimageview .openseadragon-canvas {
  outline: none; /* fix for outline appearing on some computers, e.g., Microsoft Surface */
}
</style>

