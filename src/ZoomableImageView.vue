<!--<template>
  <div id="zoomableimageview"></div>
</template>-->

<script lang="coffee">
import OpenSeadragon from 'openseadragon'
import SVGOverlay from '../lib/openseadragon-svg-overlay.js'
import ZoomifyTileSource from '../lib/zoomifytilesource.js'
import ZoomableImageOverlay from './ZoomableImageOverlay.vue'
import Vue from 'vue'

export default {
  render: (createElement) -> createElement 'div', {attrs: {id: 'zoomableimageview'}}

  props:
    config:
      type: Object
      required: true

  computed:
    nodes: () -> @$store.state.nodes
    target: () -> @$store.state.target

  watch:
    target: (newTarget) -> 
      if newTarget is undefined 
        @viewer.viewport.setMargins({left: 20, right: 20, top: 0, bottom: 0})
      else
        @viewer.viewport.setMargins({left: 428, right: 20, top: 0, bottom: 0})

      @svg_overlay.resize()

  mounted: () ->
    ### OpenSeadragon viewer creation
    ###
    @viewer = OpenSeadragon @config

    @viewer.addHandler 'open', (event) =>
      @viewer.controls[0].destroy()

      if @nodes?
        ### Image to viewport coordinates conversion
        ###
        @nodes = @nodes.map (d) => 
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

        ### SVG overlay creation
        ###
        @svg_overlay = @viewer.svgOverlay()
        OverlayComponent = Vue.extend(ZoomableImageOverlay)
        
        overlay_component = new OverlayComponent({propsData: {data: @nodes, store: @$store}})
        overlay_component.$mount()
        @$el.querySelector('svg g').appendChild(overlay_component.$el)

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
