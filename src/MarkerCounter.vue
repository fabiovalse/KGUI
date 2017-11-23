<template>
  <g class="markercounter"
    v-if="count != undefined"
    transform="translate(11.5, -11.5)"
  >
    <circle
      r="8"
    ></circle>
    <text dy="0.35em">{{count}}</text>
  </g>
</template>

<script lang="coffee">
import config from './config.coffee'

export default {
  props: ['data']

  data: () ->
    count: undefined
    interval_id: undefined

  mounted: () ->
    @tick()
    @start()
  
  beforeDestroy: () ->
    @stop()

  methods:
    tick: () ->

      # FIXME this should not be hardcoded
      if @data._key is 'ciclopi@area.cnr.it'
        _this = @
        fetch('http://wafi.iit.cnr.it:8529/_db/campusmap/_api/simple/all', {
          method: "PUT"
          body: JSON.stringify({"collection": "ciclopi"})
          headers: {Authorization: config.db.auth}
        })
        .then (response) -> response.json()
        .then (data) ->
          data = data.result[0]
          _this.count = data.free_bikes
      else
        @count = 99

    start: () -> 
      @interval_id = setInterval (() => @tick()), 1000 * 30
    stop: () ->
      clearInterval @interval_id

}
</script>

<style scoped>
.markercounter circle {
  fill: #466DB4;
}
.markercounter text {
  text-anchor: middle;
  font-weight: bold;
  font-size: 10px;
  fill: #FFF;
}
</style>
