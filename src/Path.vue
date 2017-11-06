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

      <g class="floorswitchpoint"
        v-for="p in floorswitchpoints"
        v-if="floorswitchpoints != undefined && p.floor == current_floor"
        @click="change_floor(p)"
        :transform="'translate('+p.x+','+p.y+') scale('+(transform != undefined ? 1/transform.k : 1)+')'">
        <foreignObject x="-50" y="-150" width="5" height="5">
          <i v-if="p.floorswitch == 'up'" class="icon icon-arrow-up" title="Sali al piano superiore"></i>
          <i v-if="p.floorswitch == 'down'" class="icon icon-arrow-down" title="Scendi al piano inferiore"></i>
        </foreignObject>
      </g>

      <circle v-if="current_floor == path[0].floor"
        class="starting_point"
        :style="{'stroke-width': 20/transform.k}"
        :r="50/transform.k"
        :cx="path[0].x"
        :cy="path[0].y"
      ></circle>
    </g>
    <g v-for="(w, i) in waypoints" :key="i" :transform="get_transform(w)">
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
    
    floorswitchpoints: () -> 
      if @$store.state.selection.directions? and @$store.state.selection.directions.path?
        path = @$store.state.selection.directions.path.filter (d) -> d.multifloor?

        return path.map (d,i) ->
          if path[i+1]?
            if d.floor < path[i+1].floor
              d.floorswitch = 'up'
              path[i+1].floorswitch = 'down'
            else
              d.floorswitch = 'down'
              path[i+1].floorswitch = 'up'
          return d
      else
        return undefined
    
    transform: () -> @$store.state.additional.transform

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
    get_transform: (w) -> "translate(#{w.x}, #{w.y}) scale(#{if @transform? then 1/@transform.k else 1})"
    change_floor: (p) ->
      @$emit 'changed', if p.floorswitch is 'up' then p.floor+1 else p.floor-1

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

.starting_point {
  fill: #FFF;
  stroke: #000;
}

.floorswitchpoint {
  cursor: pointer;
  fill: #FFF;
}
.floorswitchpoint .icon {
  display: block;
  width: 100px;
  height: 100px;
  font-size: 100px;
  text-align: center;
  background: #FFF;
  border-radius: 50px;
}
</style>
