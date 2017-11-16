<template>
  <g class="directions_path" v-if="path !== undefined">
    <g>
      <path
        class="path bg"
        :d="get_d()"
      />
      <path
        class="path fg"
        :d="get_d()"
      />

      <circle v-if="current_floor == path[0].floor"
        class="starting_point"
        :style="{'stroke-width': 5/k}"
        :r="10/k"
        :cx="path[0].x"
        :cy="path[0].y"
      ></circle>
    </g>
    <g v-for="(w, i) in waypoints" :key="i" :transform="get_transform(w)">
      <circle
        class="waypoint"
        :r="2.5"
      ></circle>
    </g>
  </g>
</template>

<script lang="coffee">
export default {
  props: ['current_floor', 'transform', 'transform_resize']

  computed:
    path: () -> 
      if @$store.state.selection.directions? and @$store.state.selection.directions.path?
        return @$store.state.selection.directions.path
      else
        return undefined
    
    waypoints: () -> if @$store.state.selection.directions? then @$store.state.selection.directions.path.filter((n) => not n.template? and n.floor is @current_floor) else undefined     
    
    starting_floor: () ->
      if @$store.state.selection.directions? and @$store.state.selection.directions.path?
        new_path = @$store.state.selection.directions.path
        starting_point_floors = new_path
          .filter (d) -> d._id is new_path[0]._id
          .map (d) -> +d.floor

        main_floor = new_path.filter (d) -> d.main?

        # Use the main floor if exists
        if main_floor.length is 1
          return main_floor[0].floor
        else if @current_floor in starting_point_floors
          return @current_floor
        # Use the lowest floor if the starting point has multiple floors
        else if @current_floor not in starting_point_floors
          return d3.min(starting_point_floors)
    
    k: () -> @transform.k * @transform_resize.k

  watch:
    path: (new_path) ->
      if new_path? and @starting_floor?
        @$emit 'changed', @starting_floor

  methods:
    get_d: () ->
      path = @path
        .map (d,i) -> {d..., index: i}
        .filter (d) => +d.floor is @current_floor

      if path.length > 0 and not(path.length is 2 and path.length < @path.length and path[0].index isnt path[1].index+1)
        return "M#{path[0].x} #{path[0].y}" + path.slice(1).map((d) -> " L#{d.x} #{d.y}").join('')
      else
        return ''
    get_transform: (w) -> "translate(#{w.x}, #{w.y}) scale(#{if @transform? then 1/@k else 1})"  

}
</script>

<style scoped>
.path {
  fill: none;
  stroke: #00B3FD;
  stroke-width: 7px;
  vector-effect: non-scaling-stroke;
  stroke-linejoin: round;
}
.path.bg {
  stroke: #417c94;
  stroke-width: 9px;
}

.waypoint {
  fill: #FFF;
  stroke-width: 15px;
}
</style>
