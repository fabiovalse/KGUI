<template>
  <div id="zoomableimageview">
  </div>
</template>

<script lang="coffee">
import OpenSeadragon from 'openseadragon'
import SVGOverlay from '../lib/openseadragon-svg-overlay.js'
import ZoomableImageOverlay from './ZoomableImageOverlay.vue'
import Vue from 'vue'

export default {
  props:
    config:
      type: Object
      required: true
    overlay:
      type: Object

  mounted: () ->
    ### OpenSeadragon viewer creation
    ###
    @viewer = OpenSeadragon @config

    ### SVG overlay creation
    ###
    svg_overlay = @viewer.svgOverlay()

    OverlayComponent = Vue.extend(ZoomableImageOverlay)
    overlay_component = new OverlayComponent({propsData: {data: @overlay.data}})
    overlay_component.$mount()

    @$el.querySelector('svg g').appendChild(overlay_component.$el)

    ### Click event registration
    ###
    @$el.querySelectorAll(@overlay.selector).forEach (d) =>
      svg_overlay.onClick(d, () =>
        @overlay.data[0].width = 0.1
        console.log('click', arguments)
      )
}
</script>

<style scoped>
  #zoomableimageview {
    width: 100%;
    height: 100%;
    background: #000;
  }
</style>
