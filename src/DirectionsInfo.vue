<template>
  <div class="directionsinfo">
    <!-- Directions path information -->
    <div v-if="path !== undefined">
      <div class="title">
        <div>{{get_time(weight*meter_factor)}}</div>
        <div>{{get_space(weight*meter_factor)}}</div>
      </div>
      <svg class="path" :style="{height: svg_height}">
        <g transform="translate(10,0)">
          <g>
            <line
              x1="0"
              :y1="y_start"
              x2="0"
              :y2="y_start+(poi_path.length-1)*y_tick"
            ></line>
          </g>
          <g v-for="(node,i) in poi_path" :key="i" :transform="'translate(0,' + (y_start+i*y_tick) + ')'">
            <g v-if="i == 0">
              <circle
                class="starting_point"
                r="6"
              ></circle>
              <text
                x="20"
                y="6"
              >{{node.label}}</text>
            </g>
            <g v-else-if="i < poi_path.length-1">
              <text
                class="intermediate_point"
                x="30"
                y="6"
              >{{node.label}}</text>
            </g>
            <g v-else class="ending_point">
              <circle r="6"></circle>
              <circle r="1"></circle>
              <text
                x="20"
                y="6"
                @click="select_ending_point(node)"
              >{{node.label}}</text>
            </g>
          </g>
        </g>
      </svg>
    </div>

    <!-- Events of today -->
    <div class="events" v-if="events != [] && to == null">
      <div class="title">Raggiungi un evento:</div>
      <div class="event" v-for="event in events">
        <router-link :to="{name: 'goto_directions', params: {space: space._key, from: from._key, to: event.room}}">
          <span class="info">{{event.from}}-{{event.to}}</span>
          <span class="main">{{event.label}}</span>
          <span class="info">({{event.room.split('@')[0]}})</span>
        </router-link>
      </div>
    </div>
  </div>
</template>

<script lang="coffee">
export default {

  data: () ->
    human_walking_speed: 1.25
    y_start: 15
    y_tick: 30

  computed:
    path: () -> @$store.state.selection.directions.path
    events: () -> @$store.state.additional.events
    space: () -> @$store.state.selection.space
    from: () -> @$store.state.selection.directions.from
    to: () -> @$store.state.selection.directions.to
    poi_path: () ->
      path = @path
        .filter (d) -> not d.waypoint
      return path
        .map (d,i) ->
          # the first multifloor point is the first in the path
          if d.multifloor and i == 0
            d.label = if d.floorswitch is 'up' then 'Sali le scale' else 'Scendi le scale'
          # the last multifloor point is the last in the path
          else if d.multifloor and i == path.length-1
            d.label = "Piano #{d.floor}"

          # first multifloor point
          else if d.multifloor and path[i-1]? and not(path[i-1].multifloor?)
            d.label = if d.floorswitch is 'up' then 'Sali le scale' else 'Scendi le scale'
          # intermediate multifloor point
          else if d.multifloor and path[i-1]? and path[i-1].multifloor and path[i+1]? and path[i+1].multifloor
            d.label = if path[i-1].floorswitch is 'up' then 'Sali ancora le scale' else 'Scendi ancora le scale'
          # last multifloor point
          else if d.multifloor and path[i-1]? and path[i-1].multifloor
            d.label = "Piano #{d.floor}"
          return d
    meter_factor: () -> if @$store.state.selection.space? then @$store.state.selection.space.units.m else undefined
    weight: () -> @$store.state.selection.directions.weight
    svg_height: () -> @poi_path.length * 32

  methods:
    get_time: (distance) ->
      time = distance/@human_walking_speed

      min = Math.floor(time / 60)
      sec = Math.floor(time - min * 60)

      return "#{min} min #{sec} sec"

    get_space: (distance) ->
      return "#{distance.toFixed(1)} m"

    select_ending_point: (d) ->
      @$store.commit 'goto_target', d._key

}
</script>

<style scoped>
.directionsinfo {
  padding: 15px;
  margin-top: 40px;
  font-size: 14px;
}

.title {
  font-size: 15px;
  font-weight: 400;
  margin: 10px 0px;
}
.title div:nth-child(2) {
  font-size: 13px;
  color: rgba(0,0,0,0.54);
}

.path {
  width: 100%;
}

.path line {
  stroke: #00B3FD;
  stroke-width: 10px;
}
.path .starting_point {
  fill: #FFF;
  stroke: #000;
  stroke-width: 3px;
}
.path .ending_point circle {
  fill: #FFF;
  stroke: #000;
  stroke-width: 3px;
}
.path .ending_point text {
  cursor: pointer;
}
.path .intermediate_point {
  fill: rgba(0,0,0,0.54);
}

/*  Events of the day
*/
.events {
  width: 100%;
  background: #FFF;
  box-sizing: border-box;
}
.events .title {
  font-size: 14px;
}
.events .event {
  font-size: 12px;
  font-weight: bold;
  padding: 10px;
  cursor: pointer;
}
.events .event a {
  text-decoration: none;
  color: #000;
}
.events .event:hover {
  background: #F2F2F2;
}
.events .event .info {
  color: #8C8C8C;
}
</style>
