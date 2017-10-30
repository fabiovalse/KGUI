<template>
  <g class="directions_path" v-if="path !== undefined">
    <g>
      <path
        class="path"
        :d="get_d()"
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
    path: () -> 
      if @$store.state.selection.directions? and @$store.state.selection.directions.path?
        return @$store.state.selection.directions.path
      else
        return undefined
    waypoints: () -> if @$store.state.selection.directions? then @$store.state.selection.directions.path.filter((n) => not n.template? and n.floor is @current_floor) else undefined
    transform: () -> @$store.state.additional.transform

  watch:
    path: (new_path) ->
      if new_path?
        starting_point_floors = new_path
          .filter (d) -> d._id is new_path[0]._id
          .map (d) -> +d.floor

        main_floor = new_path.filter (d) -> d.main?

        console.log starting_point_floors
        console.log main_floor

        # Use the main floor if exists
        if main_floor.length is 1
          @$emit 'changed', main_floor[0].floor

        # Use the lowest floor if the starting point has multiple floors
        if not(@current_floor of starting_point_floors)
          @$emit 'changed', d3.min(starting_point_floors)

  methods:
    get_d: () ->
      path = @path
        .map (d,i) -> {d..., index: i}
        .filter (d) => +d.floor is @current_floor

      if path.length > 0 and not(path.length is 2 and path.length < @path.length and path[0].index isnt path[1].index+1)
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
