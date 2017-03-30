<!--<template>
  <div id="zoomableimageview"></div>
</template>-->

<script lang="coffee">
import OpenSeadragon from 'openseadragon'
import SVGOverlay from '../lib/openseadragon-svg-overlay.js'
import ZoomableImageOverlay from './ZoomableImageOverlay.vue'
import Vue from 'vue'

export default {
  render: (createElement) -> createElement 'div', {attrs: {id: 'zoomableimageview'}}

  props:
    config:
      type: Object
      required: true

  computed:
    cartouches: () -> @$store.state.nodes

  data: () ->
    overlay: [
      {
        selector: 'rect',
        x1: 42972.12,
        y1: 108.74,
        x2: 45134.573418426706,
        y2: 1551.8663143384158
      },
      {
        selector: 'rect',
        x1: 42972.12,
        y1: 1551.8663143384158,
        x2: 45134.573418426706,
        y2: 20324.736324745765
      },
      {
        selector: 'path',
        points: [
          {x: 5621.1834304051945, y: 5361.071445139335},
          {x: 9016.467857233447, y: 4446.956407147114},
          {x: 12231.416664321738, y: 3794.017094295527},
          {x: 12306.038300076207, y: 4216.873030237506},
          {x: 8966.720100063803, y: 4882.2492823815055},
          {x: 5677.149657221045, y: 5678.213397095822}
        ]
      },
      {
        selector: 'circle',
        cx: 2363.461610242892,
        cy: 2585.3094454532816,
        rx: 4648.408785629651
      }
    ]

  mounted: () ->
    ### OpenSeadragon viewer creation
    ###
    @viewer = OpenSeadragon @config

    @viewer.addHandler 'open', (event) =>
      @viewer.controls[0].destroy()

      if @overlay?
        ### Image to viewport coordinates conversion
        ###
#        @overlay.map (d) => 
#          if d.x1? and d.y1?
#            p = @viewer.viewport.imageToViewportCoordinates d.x1, d.y1
#            d.x1 = p.x
#            d.y1 = p.y
#          if d.x2? and d.y2?
#            p = @viewer.viewport.imageToViewportCoordinates d.x2, d.y2
#            d.x2 = p.x
#            d.y2 = p.y
#          if d.cx? and d.cy?
#            p = @viewer.viewport.imageToViewportCoordinates d.cx, d.cy
#            d.cx = p.x
#            d.cy = p.y
#
#            d.rx = @viewer.viewport.imageToViewportCoordinates(d.rx).x
#          if d.points?
#            d.points = d.points.map (p) => @viewer.viewport.imageToViewportCoordinates p.x, p.y

        @cartouches = @cartouches.map (d) => 
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
            d.data.points = d.points.map (p) => @viewer.viewport.imageToViewportCoordinates p.x, p.y

        ### SVG overlay creation
        ###
        svg_overlay = @viewer.svgOverlay()
        OverlayComponent = Vue.extend(ZoomableImageOverlay)
        
        overlay_component = new OverlayComponent({propsData: {data: @cartouches, store: @$store}})
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
