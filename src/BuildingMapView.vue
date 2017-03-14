<template>
  <div>
    <svg :viewBox="config.buildingmapview.viewbox">
      <g :transform="transform">
        <floor v-if="check(floor)" v-for="floor in spaces" :data="floor"></floor>
        
        <directionpath></directionpath>
        <poi v-for="(poi,i) in pois" :data="poi"></poi>
        <placemark></placemark>
      </g>
    </svg>
    <floorselector></floorselector>
  </div>
</template>

<script lang="coffee">
import Floor from './Floor.vue'
import FloorSelector from './FloorSelector.vue'
import Poi from './Poi.vue'
import Placemark from './Placemark.vue'
import Path from './Path.vue'

export default {
  props: ['config']

  computed:
    transform: () -> @$store.state.transform
    pois: () -> if @$store.state.nodes? then @$store.state.nodes else []
    spaces: () -> if @$store.state.spaces? then @$store.state.spaces.filter((d) -> d.urls?).reverse() else undefined
    selected_space: () -> if @$store.state.spaces? then @$store.state.spaces.filter((d) -> d.urls? and d.current)[0] else undefined

  mounted: () ->
    zoom = d3.zoom()
      .scaleExtent(@config.buildingmapview.zoom_scale_extent)
      .on 'zoom', () =>
        @$store.commit 'set_transform', d3.event.transform

    d3.select(@$el).select('svg').call zoom

  components:
    floor: Floor
    floorselector: FloorSelector
    poi: Poi
    placemark: Placemark
    directionpath: Path

  methods:
    check: (floor) -> if floor.index <= @selected_space.index then true else false

}
</script>

<style scoped>
svg {
  width: 100%;
  height: 100%;
}

.floorselector {
  position: absolute;
  bottom: 10px;
  left: 10px;
}
</style>
