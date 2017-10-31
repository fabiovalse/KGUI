<template>
  <div v-if="path !== undefined" class="directionsinfo">
    <div class="title">
      <b>{{get_time(weight*meter_factor)}}</b> ({{get_space(weight*meter_factor)}})
    </div>
    <div class="info" v-for="(node,i) in poi_path" :key="i">
      <div class="text">{{node.label}}</div>
    </div>
  </div>
</template>

<script lang="coffee">
export default {

  data: () ->
    human_walking_speed: 1.25

  computed:
    path: () -> @$store.state.selection.directions.path
    poi_path: () -> @path.filter (d) -> not d.waypoint
    meter_factor: () -> if @$store.state.selection.space? then @$store.state.selection.space.units.m else undefined
    weight: () -> @$store.state.selection.directions.weight

  methods:
    get_time: (distance) ->
      time = distance/@human_walking_speed

      min = Math.floor(time / 60)
      sec = Math.floor(time - min * 60)

      return "#{min}m #{sec}s"

    get_space: (distance) ->
      return "#{distance.toFixed(1)} m"
}
</script>

<style scoped>
.directionsinfo {
  padding: 15px;
  margin-top: 40px;
}

.title {
  font-size: 20px;
  margin-bottom: 20px;
}

.info {
  display: flex;
  margin: 10px;
}
.info .icon {
  width: 60px;
  text-align: left;
}
.info .text {
  flex-grow: 1;
  font-size: 15px;
}
.info .partial_distance {
  width: 60px;
  text-align: right;
  color: #BBB;
}

.expand {
  display: none;
  text-align: center;
}

@media (max-width: 480px) {
  .expand {
    display: inline;
  }
}

</style>
