<script lang="coffee">
import OpenSeadragon from 'openseadragon'
import SVGOverlay from '../lib/openseadragon-svg-overlay.js'
import ZoomifyTileSource from '../lib/zoomifytilesource.js'
import ZoomableImageOverlay from './ZoomableImageOverlay.vue'
import SpaceSwitch from './SpaceSwitch.vue'
import RotationControl from './RotationControl.vue'
import Vue from 'vue'
import _ from 'lodash'
import * as d3 from 'd3'

export default {

  render: (createElement) ->
    elements = []

    # Zoom controls +/-
    elements.push createElement 'div', {
      class: 'zoom_control hidden'
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

    if @fullscreen
      # Space switch
      elements.push createElement 'spaceswitch', {}

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

    if @fullscreen and @config.compass
      # Rotation Control
      elements.push createElement 'rotationcontrol', {
        class: 'rotationcontrol'
        props:
          value: @degrees
          type: @config.compass
        on:
          input: (value) =>
            @degrees = value-@offset
            @rotate value+@offset
      }

    # SVG Overlay
    if @svg_overlay?
      OverlayComponent = Vue.extend(ZoomableImageOverlay)
      overlay_component = new OverlayComponent
        data:
          nodes: @converted_nodes
          store: @$store
          viewer: @viewer
          annotations: if @config.annotations? then @config.annotations else {}
      overlay_component.$mount()
      @$el.querySelector('.openseadragon-container svg g').appendChild(overlay_component.$el)
      
      # Add CSS mix blend mode style
      @$el.querySelector('.openseadragon-container svg').style['mix-blend-mode'] = 'multiply'
      
      @show_hide()

    # Overall "template"
    elements.push createElement 'div', {
      attrs:
        id: "zoomableimageview"
      'class':
        fullscreen: @fullscreen
        zoom_cursor: not @fullscreen
      style:
        background: @config.background_color
      on:
        'keyup': (event) =>
          if event.key is 'Escape'
            event.stopPropagation()
            @$emit('close')
    }

    return createElement 'div', {
      class: "zoomableimageview_container"
    }, elements

  data: () ->
    initial_pan: undefined
    initial_zoom: undefined
    annotation_visible: true
    svg_overlay: undefined
    degrees: 0
    mercator: d3.geoMercator()
      .translate [0.5, 0.5]
      .scale 1/(2*Math.PI)
    
    default_config:
      openseadragon:
        id: 'zoomableimageview'
        prefixUrl: 'https://rawgit.com/fabiovalse/Hub/master/lib/openseadragon/images/'
        mouseNavEnabled: false
        springStiffness: 5
        animationTime: 0
        zoomInButton: 'openseadragon_zoom_in_control'
        zoomOutButton: 'openseadragon_zoom_out_control'
        degrees: 0                      # Initial rotation angle
        gestureSettingsMouse:
          flickEnabled: true
          flickMomentum: 0
          clickToZoom: false
          dblClickToZoom: true
        gestureSettingsTouch:
          flickEnabled: true
          flickMomentum: 0
          clickToZoom: false
          dblClickToZoom: true
        gestureSettingsPan:
          flickEnabled: true
          flickMomentum: 0
          clickToZoom: false
          dblClickToZoom: true
        gestureSettingsUnknown:
          flickEnabled: true
          flickMomentum: 0
          clickToZoom: false
          dblClickToZoom: true
      background_color: 'black'
      compass: false

    class_declaration:
      rotatable:
        openseadragon:
          showRotationControl: true     # Show rotation buttons
          gestureSettingsTouch:         # Enable touch rotation on tactile devices
            pinchRotate: true
        compass: 'geometric'
    
    openseadragon_templates:
      dzi: (d) -> {tileSource: d.url}
      esri: (d) -> {
        tileSource:
          getTileUrl: (z, x, y) -> "http://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/#{z-8}/#{y}/#{x}"
          height: (1<<24)*256
          width:  (1<<24)*256
          tileSize: 256
      }
      gdal2tiles: (d) -> {
        tileSource:
          getTileUrl: (level, x, y) ->
            level -= 8
            yTiles = 1 << level
            return d.url + '/' + level + "/" + x + "/" + (yTiles - y - 1) + ".png"
          width: (1<<20)*256
          height: (1<<20)*256
          tileSize: 256
      }

  props:
    fullscreen:
      type: Boolean
      'default': true
    closeable:
      type: Boolean
      'default': false

  computed:
    space: () -> @$store.state.selection.space
    config: () ->
      conf = @load_config @default_config, @space.config, @space.classes, @class_declaration

      # Compute tilesources using specific templates
      conf.openseadragon.tileSources = conf.openseadragon.tileSources.map (ts) => @openseadragon_templates[ts.type](ts)
      return conf

  watch:
    space: (newSpace) -> @init()
    fullscreen: (n, o) -> @refresh(n, o)
    annotation_visible: () -> @show_hide()

  mounted: () -> @init()

  methods:
    init: () ->
      @offset = @config.openseadragon.degrees

      # Handle new tiled image loading
      if @viewer? and @viewer.world.getItemCount() > 0
        @svg_overlay = undefined
        @initial_zoom = undefined
        @degrees = @config.openseadragon.degrees
        @viewer.destroy()

      # OpenSeadragon viewer creation
      @viewer = OpenSeadragon @config.openseadragon

      # Set margins according to infobox
      @viewer.viewport.setMargins({left: 20, right: 20, top: 0, bottom: 0})

      @load_map()
      @refresh(@fullscreen)

    refresh: (new_value, old_value) ->
      # go to fullscreen
      if not old_value and new_value
        @viewer.setMouseNavEnabled true
        @annotation_visible = true
        @$el.querySelector('.zoom_control').classList.remove('hidden')

      # exit fullscreen
      else if old_value and not new_value
        @viewer.setMouseNavEnabled false
        @$el.querySelector('.zoom_control').classList.add('hidden')

        # set initial view
        if @space.geo_bounds?
          @change_opacity 1
          @fit_bounds()
        else
          @viewer.viewport.goHome true
        
        @degrees = @config.openseadragon.degrees
        @rotate @degrees

      @show_hide()

    show_hide: () -> 
      svg = @$el.querySelector('.openseadragon-container svg')
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

    change_opacity: (value) -> @viewer.world.getItemAt(1).setOpacity value

    rotate: (value) -> @viewer.viewport.setRotation(value)

    load_map: () ->
      new_zoom = @initial_zoom
      new_pan = @initial_pan

      ### Store every zoom & pan change
      ###
      @viewer.addHandler 'pan', (event) =>
        @initial_pan = event.center
      @viewer.addHandler 'zoom', (event) =>
        @initial_zoom = event.zoom

      ### Update degrees on rotate
      ###
      @viewer.addHandler 'rotate', (event) =>
        @degrees = event.degrees-@offset

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
    rotationcontrol: RotationControl

}
</script>

<style scoped>
.zoomableimageview_container {
  width: 100%;
  height: 100%;
}

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
.hidden {
  display: none;
}
.zoom_cursor {
  cursor: zoom-in;
}

.zoom_control {
  position: absolute;
  bottom: 15px;
  right: 37px;
  z-index: 5;
}
.zoom_control .in, .zoom_control .out {
  width: 30px;
  height: 30px;
  background: #FFF;
  border: none;
  border-bottom: 1px solid #F2F2F2;
  box-shadow: 0px 1px 4px rgba(0,0,0,0.3);
  color: rgb(178, 178, 178);
  outline: none;
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
  right: 37px;
  z-index: 5;
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
  outline: none;
  font-size: 14px;
}
.annotation_control button:hover {
  color: rgb(100, 100, 100);
}

.opacity_control {
  position: absolute;
  top: 10px;
  right: calc((100% - 129px) / 2);
  z-index: 5;
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
  outline: none;
  z-index: 5;
}
</style>
<style>
#zoomableimageview .openseadragon-canvas {
  outline: none; /* fix for outline appearing on some computers, e.g., Microsoft Surface */
}
</style>

