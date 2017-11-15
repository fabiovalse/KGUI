<template>
  <div class="buildingmapview">
    <svg :style="{background: space.background_color}">
      <g v-if="transform != undefined" :transform="transform">
        <g  v-if="transform_resize != undefined" :transform="transform_resize">
          <floor v-if="check(i)" 
            v-for="(floor,i) in floors"
            :key="floor.url"
            :data="floor"
          ></floor>
          <g v-html="text_layer"></g>

          <mapmarker v-for="label in labels" 
            :key="label._id"
            :data="label"
            :transform="transform"
            :transform_resize="transform_resize"
          ></mapmarker>

          <directionpath
            :current_floor="current_floor"
            :transform="transform"
            :transform_resize="transform_resize"
            @changed="change_floor"
          ></directionpath>
          
          <mapmarker v-for="poi in pois" 
            :key="poi._id"
            :data="poi"
            :transform="transform"
            :transform_resize="transform_resize"
          ></mapmarker>

          <placemark
            :transform="transform"
            :transform_resize="transform_resize"
          ></placemark>
        </g>
      </g>
    </svg>
    <floorselector
      :current_floor="current_floor"
      @select="change_floor"
    ></floorselector>
    <weatherpanel v-if="config.weather"></weatherpanel>
  </div>
</template>

<script lang="coffee">
import config from './config.coffee'
import Floor from './Floor.vue'
import FloorSelector from './FloorSelector.vue'
import Marker from './Marker.vue'
import Placemark from './Placemark.vue'
import Path from './Path.vue'
import WeatherPanel from './WeatherPanel.vue'

export default {

  data: () ->
    current_floor: @$store.state.selection.space.starting_floor
    text_layer: ''
    width: document.body.getBoundingClientRect().width
    height: document.body.getBoundingClientRect().height
    transform: undefined
    transform_resize: undefined

  computed:
    pois: () ->
      if @$store.state.selection.space.nodes?
        @$store.state.selection.space.nodes
          .filter (n) -> n? and n.template is 'poi' 
          .filter (n) => @current_floor is +n.floor
      else
        []
    labels: () -> 
      if @$store.state.selection.space.nodes?
        @$store.state.selection.space.nodes
          .filter (n) -> n? and n.template is 'room'
          .filter (n) => @current_floor is +n.floor
      else
        []
    floors: () -> if @$store.state.selection.space? and @$store.state.selection.space.floors? then @$store.state.selection.space.floors else undefined
    space: () -> @$store.state.selection.space
    target: () -> @$store.state.selection.target
    viewbox: () -> @$store.state.selection.space.viewbox
    config: () -> config

  watch: 
    target: (t) ->
      # When a new target is selected its floor is set as current
      # - if it has one
      # - if it not selected already
      if t? and t.floors.length > 0 and not(@current_floor in t.floors)
        @change_floor t.floor

      # When a new target is selected the view is centered on the target coordinates
      if t? and t.x? and t.y?
        @center t

  mounted: () ->
    # Add a listener for window resize
    window.addEventListener 'resize', @update_size
    @update_size()

    # Initialize transform
    @transform = d3.zoomIdentity

    # Set a zoom behaviour
    @svg = d3.select(@$el).select('svg')
    @zoom = d3.zoom()
      .scaleExtent(@space.zoom_scale_extent)
      .on 'zoom', () =>
        @transform = d3.event.transform
    @svg.call @zoom

    # Adding layer containg text for street names
    d3.text "#{@space.text_layer}", (text_layer) =>
      @text_layer = text_layer

  methods:
    update_size: () ->
      @width = document.body.getBoundingClientRect().width
      @height = document.body.getBoundingClientRect().height

      @transform_resize = d3.zoomIdentity
        .translate @width/2, @height/2
        .scale Math.min @width/@viewbox[2], @height/@viewbox[3]
        .translate -@viewbox[2]/2, -@viewbox[3]/2
        .translate -@viewbox[0], -@viewbox[1]

    check: (floor_index) -> floor_index <= @current_floor

    change_floor: (floor_index) ->
      @current_floor = floor_index

    center: (d) ->
      k = @transform.k

      new_center = @transform_resize.apply [d.x, d.y]
      center = {
        x: new_center[0]
        y: new_center[1]
      }

      @transform = @to_bounding_box(@width, @height, center, @width/k, @height/k, 0)
      #@svg.call @zoom.transform, @transform
      @zoom.transform @svg, @transform
    
    to_bounding_box: (W, H, center, w, h, margin) ->
      kw = (W - margin) / w
      kh = (H - margin) / h
      
      k = d3.min [kw, kh]

      x = W/2 - center.x*k
      y = H/2 - center.y*k

      return d3.zoomIdentity
        .translate x, y
        .scale k

  components:
    floor: Floor
    floorselector: FloorSelector
    mapmarker: Marker
    placemark: Placemark
    directionpath: Path
    weatherpanel: WeatherPanel

}
</script>

<style scoped>
svg {
  width: 100%;
  height: 100%;
}

.buildingmapview {
  width: 100%;
  height: 100%;
}

.floorselector {
  position: absolute;
  bottom: 10px;
  right: 10px;
}

.weatherpanel {
  position: absolute;
  top: 10px;
  right: 10px;
}

@media (max-width: 480px) {
  .mobile_mode .floorselector {
    right: 10px;
    bottom: 120px;
  }
}

</style>
