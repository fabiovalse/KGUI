<template>
  <div class="weatherpanel">
    <div class="temperature">
      <div class="current" title="Temperatura attuale">{{data.temp_c}}°</div>
      <div>
        <span class="max" title="Temperatura massima giornaliera">{{data.heat_index_c}}°</span>
        <span class="min" title="Temperatura minima giornaliera">{{data.dewpoint_c}}°</span>
      </div>  
    </div>
    <table class="info">
      <tr title="Percentuale di umidità">
        <td><i class="icon-humidity"></i></td>
        <td>{{data.relative_humidity}}%</td>
      </tr>
      <tr title="Millimetri di pioggia">
        <td><i class="icon-rain"></i></td>
        <td>{{data.rain_day_in}}mm</td>
      </tr>
      <tr title="Velocità vento in chilometri orari">
        <td><i class="icon-wind"></i></td>
        <td>{{data.wind_kt}}km/h</td>
      </tr>
    </table>
  </div>
</template>

<script lang="coffee">
import db from './database.coffee'

export default {

  data: () ->
    data: {}

  mounted: () ->
    @tick()
    @start()
  
  beforeDestroy: () ->
    @stop()

  methods:
    tick: () ->
      cb = (data) =>
        if data?
          @data = data[0]
      db.execute_arango "FOR doc IN weather RETURN doc", cb, null, {}

    start: () -> 
      @interval_id = setInterval (() => @tick()), 1000 * 60
    stop: () ->
      clearInterval @interval_id
}
</script>

<style scoped>
.weatherpanel {
  display: flex;
  justify-content: space-between;
  width: 140px;
  height: 55px;
  background: #F5F5F5;
  box-shadow: var(--box-shadow);
  border-radius: 3px;
  padding: 10px;
}

.temperature .current {
  font-size: 30px;
}
.temperature .max, .temperature .min {
  font-size: 13px;
}
.temperature .max {
  font-weight: bold;
  color: #BBB;
}
.temperature .min {
  color: #CCC; 
}

.info {
  font-size: 12px;
  color: #BBB;
  border-collapse: collapse;
}
.info i {
  font-size: 15px;
  color: #888;
  padding-right: 3px;
}
</style>
