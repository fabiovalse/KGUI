<template>
  <g class="markercounter"
    v-if="free_bikes != undefined"
    transform="translate(15, -15)"
  >
    <circle
      r="10"
    ></circle>
    <text dy="0.35em">{{free_bikes}}</text>
  </g>
</template>

<script lang="coffee">
import config from './config.coffee'

export default {
  props: ['data']

  data: () ->
    free_bikes: undefined
    interval_id: undefined

  mounted: () ->
    @tick()
    @start()
  
  beforeDestroy: () ->
    @stop()

  methods:
    tick: () ->
      _this = @
      fetch('http://wafi.iit.cnr.it:8529/_db/campusmap/_api/simple/all', {
        method: "PUT"
        body: JSON.stringify({"collection": "ciclopi"})
        headers: {Authorization: config.db.auth}
      })
      .then (response) -> response.json()
      .then (data) ->
        data = data.result[0]
        _this.free_bikes = data.free_bikes

    start: () -> 
      @interval_id = setInterval (() => @tick()), 1000 * 30
    stop: () ->
      clearInterval @interval_id

}
</script>

<style scoped>
.markercounter circle {
  fill: #B44646;
}
.markercounter text {
  text-anchor: middle;
  font-weight: bold;
  font-size: 13px;
  fill: #FFF;
}
</style>
