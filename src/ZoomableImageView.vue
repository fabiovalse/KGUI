<template>
  <div id="zoomableimageview">
    <spaceswitch></spaceswitch>
  </div>
</template>

<script lang="coffee">
import OpenSeadragon from 'openseadragon'
import SVGOverlay from '../lib/openseadragon-svg-overlay.js'
import ZoomifyTileSource from '../lib/zoomifytilesource.js'
import ZoomableImageOverlay from './ZoomableImageOverlay.vue'
import SpaceSwitch from './SpaceSwitch.vue'
import Vue from 'vue'

export default {
  #render: (createElement) -> createElement 'div', {attrs: {id: 'zoomableimageview'}}

  props:
    config:
      type: Object
      required: true

  computed:
    nodes: () -> @$store.state.nodes
    space: () -> @$store.state.space

  watch:
    space: (newSpace) -> @load_map()

  mounted: () ->
    # OpenSeadragon viewer creation
    @config.tileSources = @space.tile_source
    @viewer = OpenSeadragon @config

    # remove default zoom controls
    @viewer.controls[0].destroy()

    # set margins according to infobox
    @viewer.viewport.setMargins({left: 428, right: 20, top: 0, bottom: 0})

  methods:
    load_map: () ->
      if @viewer.isOpen()
        @viewer.open(@space.tile_source)

      @viewer.addHandler 'open', (event) =>
        
        ### Image to viewport coordinates conversion
        ###
        if not @converted_nodes?
          @converted_nodes = @nodes.map (d) => 
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
              d.data.points = JSON.parse(d.data.points).map (p) => @viewer.viewport.imageToViewportCoordinates p.x, p.y
            return d

        ### SVG overlay creation
        ###
        @svg_overlay = @viewer.svgOverlay()
        OverlayComponent = Vue.extend(ZoomableImageOverlay)
        
        overlay_component = new OverlayComponent({propsData: {data: @converted_nodes, store: @$store, viewer: @viewer}})
        overlay_component.$mount()
        @$el.querySelector('svg g').appendChild(overlay_component.$el)

        @$el.querySelector('svg').style['mix-blend-mode'] = 'multiply'

  #      ### Click event registration
  #      ###
  #      @overlay.forEach (d,i) =>
  #        @$el.querySelectorAll(d.selector).forEach (d,j) =>
  #          svg_overlay.onClick(d, () =>
  #            #console.log('click', arguments)
  #          )
  #
  #    @viewer.addHandler 'canvas-click', (event) =>
  #      # The canvas-click event gives us a position in web coordinates.
  #      webPoint = event.position;
  #
  #      # Convert that to viewport coordinates, the lingua franca of OpenSeadragon coordinates.
  #      viewportPoint = @viewer.viewport.pointFromPixel(webPoint);
  #
  #      # Convert from viewport coordinates to image coordinates.
  #      imagePoint = @viewer.viewport.viewportToImageCoordinates(viewportPoint);
  #
  #      # Show the results.
  #      #console.log(webPoint.toString(), viewportPoint.toString(), imagePoint.toString());
  #      console.log imagePoint

  components:
    spaceswitch: SpaceSwitch

}
</script>

<style scoped>
  #zoomableimageview {
    width: 100%;
    height: 100%;
    background: #000;
  }

  #zoomableimageview * {
    outline: none !important;
  }
</style>
