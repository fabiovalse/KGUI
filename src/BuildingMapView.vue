<template>
  <div class="buildingmapview">
    <svg :viewBox="space.viewbox" :style="{background: space.background_color}">
      <g :transform="transform">
        <floor v-if="check(i)" 
          v-for="(floor,i) in floors"
          :data="floor"
        ></floor>
        <g v-html="text_layer"></g>

        <directionpath
          :current_floor="current_floor"
          @changed="change_floor"
        ></directionpath>
        <poi v-for="(poi,i) in pois" 
          :data="poi"
        ></poi>
        <maplabel v-for="(label,i) in labels" 
          :data="label"
        ></maplabel>
        <icon v-for="(icon,i) in icons" :data="icon"></icon>
        <placemark></placemark>
      </g>
    </svg>
    <floorselector
      :current_floor="current_floor"
      @select="change_floor"
    ></floorselector>
  </div>
</template>

<script lang="coffee">
import Floor from './Floor.vue'
import FloorSelector from './FloorSelector.vue'
import Poi from './Poi.vue'
import Label from './Label.vue'
import Icon from './Icon.vue'
import Placemark from './Placemark.vue'
import Path from './Path.vue'

export default {

  data: () ->
    current_floor: @$store.state.selection.space.starting_floor
    text_layer: ''

  computed:
    transform: () -> @$store.state.additional.transform
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
    icons: () -> if @$store.state.selection.space.nodes? then @$store.state.selection.space.nodes.filter (n) -> n? and n.label in ['Stairs', 'Elevator', 'Toilet'] else []
    floors: () -> if @$store.state.selection.space? and @$store.state.selection.space.floors? then @$store.state.selection.space.floors else undefined
    space: () -> @$store.state.selection.space
    target: () -> @$store.state.selection.target

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
    @svg = d3.select(@$el).select('svg')
    @zoom = d3.zoom()
      .scaleExtent(@space.zoom_scale_extent)
      .on 'zoom', () =>
        @$store.commit 'set_transform', d3.event.transform
    @svg.call @zoom

    # Adding layer containg text for street names
    d3.text "#{@space.text_layer}", (text_layer) =>
      @text_layer = text_layer

  components:
    floor: Floor
    floorselector: FloorSelector
    poi: Poi
    maplabel: Label
    icon: Icon
    placemark: Placemark
    directionpath: Path

  methods:
    check: (floor_index) -> floor_index <= @current_floor

    change_floor: (floor_index) ->
      @current_floor = floor_index

    center: (d) ->
      width = @svg.node().getBoundingClientRect().width
      height = @svg.node().getBoundingClientRect().height
      k = @$store.state.additional.transform.k

      center = {
        x: d.x-1200*3/k
        y: d.y-1000*3/k
      }
      transform = @to_bounding_box(width, height, center, width/k, height/k, 0)

      @svg.call(@zoom.transform, transform)
      @$store.state.additional.transform = transform
    
    to_bounding_box: (W, H, center, w, h, margin) ->
      kw = (W - margin) / w
      kh = (H - margin) / h
      
      k = d3.min [kw, kh]

      x = W/2 - center.x*k
      y = H/2 - center.y*k

      return d3.zoomIdentity
        .translate x, y
        .scale k

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

@media (max-width: 480px) {
  .mobile_mode .floorselector {
    right: 10px;
    bottom: 120px;
  }
}

</style>
