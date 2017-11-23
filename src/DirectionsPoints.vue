<template>
  <g class="directions_points" v-if="$store.state.selection.directions != undefined">
    <circle v-if="starting_point != undefined && current_floor == starting_point.floor"
      class="starting_point"
      :style="{'stroke-width': 25/transform.k}"
      :r="60/transform.k"
      :cx="starting_point.x"
      :cy="starting_point.y"
    ></circle>

    <mapmarker v-for="p in floorswitchpoints"
      v-if="p.floor == current_floor"
      @changed="change_floor"
      :data="p"
      :transform="transform"
      :transform_resize="transform_resize"
    ></mapmarker>

    <g v-if="ending_point != undefined && current_floor == ending_point.floor">
      <g class="ending_point" :transform="'translate(' + ending_point.x + ', ' + ending_point.y + ')'">
        <circle
          :style="{'stroke-width': 25/transform.k}"
          :r="60/transform.k"
        ></circle>
        <circle
          :r="20/transform.k"
        ></circle>
      </g>
      <placemark
        :directions_target="ending_point"
        :transform="transform"
        :transform_resize="transform_resize"
      ></placemark>
    </g>
  </g>
</template>

<script lang="coffee">
import Marker from './Marker.vue'
import Placemark from './Placemark.vue'

export default {
  props: ['transform', 'transform_resize', 'current_floor']

  computed:
    starting_point: () -> if @$store.state.selection.directions? and @$store.state.selection.directions.path? then @$store.state.selection.directions.path[0] else undefined
    ending_point: () -> if @$store.state.selection.directions? and @$store.state.selection.directions.path? then @$store.state.selection.directions.path[@$store.state.selection.directions.path.length-1] else undefined
    floorswitchpoints: () -> 
      if @$store.state.selection.directions? and @$store.state.selection.directions.path?
        path = @$store.state.selection.directions.path.filter (d) -> d.multifloor?

        return path.map (d,i) ->
          if path[i+1]?
            if d.floor < path[i+1].floor
              d.floorswitch = 'up'
              d.icon = 'arrow-up'
              
              path[i+1].floorswitch = 'down'
              path[i+1].icon = 'arrow-down'
            else
              d.floorswitch = 'down'
              d.icon = 'arrow-down'

              path[i+1].floorswitch = 'up'
              path[i+1].icon = 'arrow-up'
          d.layer = 'directions'
          return d
      else
        return undefined

  methods:
    change_floor: (index) -> @$emit 'changed', index

  components:
    mapmarker: Marker
    placemark: Placemark

}
</script>

<style scoped>
.starting_point {
  fill: #FFF;
  stroke: #000;
}

.ending_point circle:first-child {
  fill: #FFF;
  stroke: #000;
}
</style>
