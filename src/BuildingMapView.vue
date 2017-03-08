<template>
  <svg :viewBox="config.buildingmapview.viewbox">
    <g :transform="transform">
      <floor v-if="check(floor)" v-for="floor in spaces" :data="floor"></floor>
      
      <path
        v-if="path !== undefined"
        class="path"
        :d="get_d(path)"
      />
      <poi v-for="(poi,i) in pois" :data="poi"></poi>
      <placemark></placemark>
    </g>
  </svg>
</template>

<script lang="coffee">
import Floor from './Floor.vue'
import Poi from './Poi.vue'
import Placemark from './Placemark.vue'

export default {
  props: ['config']

  computed:
    path: () -> @$store.state.path
    transform: () -> @$store.state.transform
    pois: () -> if @$store.state.nodes? then @$store.state.nodes else []
    spaces: () -> if @$store.state.spaces? then @$store.state.spaces.filter((d) -> d.urls?).reverse() else undefined
    selected_space: () -> if @$store.state.spaces? then @$store.state.spaces.filter((d) -> d.urls? and d.current)[0] else undefined

  mounted: () ->
    zoom = d3.zoom()
      .scaleExtent(@config.buildingmapview.zoom_scale_extent)
      .on 'zoom', () =>
        @$store.commit 'set_transform', d3.event.transform

    d3.select(@$el).call zoom

  components:
    floor: Floor
    poi: Poi
    placemark: Placemark

  methods:
    check: (floor) -> if floor.index <= @selected_space.index then true else false
    get_d: (path) ->
      str = "M#{path[0].position[0]} #{path[0].position[1]}"

      for i,p of path.slice(1)
        str += " L#{p.position[0]} #{p.position[1]}"

      return str

}
</script>

<style scoped>
svg {
  width: 100%;
  height: 100%;
}
.path {
  fill: none;
  stroke: #00B3FD;
  stroke-width: 13px;
  stroke-dasharray: 25,20;
}
</style>
