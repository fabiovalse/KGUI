<template>
  <div class="buildingmapview">
    <svg :viewBox="space.viewbox" :style="{background: space.background_color}">
      <g :transform="transform">
        <floor v-if="check(floor)" v-for="floor in spaces" :data="floor"></floor>
        
        <directionpath></directionpath>
        <poi v-for="(poi,i) in pois" :data="poi"></poi>
        <maplabel v-for="(label,i) in labels" :data="label"></maplabel>
        <icon v-for="(icon,i) in icons" :data="icon"></icon>
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
import Label from './Label.vue'
import Icon from './Icon.vue'
import Placemark from './Placemark.vue'
import Path from './Path.vue'

export default {

  computed:
    transform: () -> @$store.state.transform
    pois: () -> if @$store.state.nodes? then @$store.state.nodes.filter (n) -> n.template is 'poi' else []
    labels: () -> if @$store.state.nodes? then @$store.state.nodes.filter (n) -> n.template is 'room' else []
    icons: () -> if @$store.state.nodes? then @$store.state.nodes.filter (n) -> n.label in ['Stairs', 'Elevator', 'Toilet'] else []
    spaces: () -> if @$store.state.spaces? then @$store.state.spaces.filter((d) -> d.urls?).reverse() else undefined
    space: () -> @$store.state.space

  mounted: () ->
    zoom = d3.zoom()
      .scaleExtent(@space.zoom_scale_extent)
      .on 'zoom', () =>
        @$store.commit 'set_transform', d3.event.transform

    d3.select(@$el).select('svg').call zoom

  components:
    floor: Floor
    floorselector: FloorSelector
    poi: Poi
    maplabel: Label
    icon: Icon
    placemark: Placemark
    directionpath: Path

  methods:
    check: (floor) -> floor.order >= @space.order

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
