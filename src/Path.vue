<template>
  <g class="directions_path" v-if="path !== undefined">
    <g>
      <path
        class="path"
        :d="get_d(path)"
      />
    </g>
    <g v-for="w in waypoints" :transform="get_transform(w)">
      <circle
        class="waypoint"
        :r="10"
      ></circle>
    </g>
  </g>
</template>

<script lang="coffee">
export default {
  props: ['current_floor']

  computed:
    path: () -> if @$store.state.selection.directions? then @$store.state.selection.directions.path else undefined
    waypoints: () -> if @$store.state.selection.directions? then @$store.state.selection.directions.path.filter((n) -> not n.template?) else undefined
    transform: () -> @$store.state.additional.transform

  methods:
    get_d: (path) ->
      path = path.filter (d) => d.floor is @current_floor
      
      if path.length > 0
        return "M#{path[0].x} #{path[0].y}" + path.slice(1).map((d) -> " L#{d.x} #{d.y}").join('')
      else
        return ''
    get_transform: (w) -> "translate(#{w.x}, #{w.y}) scale(#{if @transform? then 1/@transform.k else 1})"

}
</script>

<style scoped>
.path {
  fill: none;
  stroke: #00B3FD;
  stroke-width: 7px;
  vector-effect: non-scaling-stroke;
}

.waypoint {
  fill: white;
  stroke-width: 15px;
}

</style>
