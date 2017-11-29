<template>
  <div class="weatherpanel">
    <div class="city">PISA</div>
    <div class="time">
      <span>{{day_str}}</span> | <span>{{day}} {{month}}</span> | <span>{{time}}</span>
    </div>
    <div class="temperature">
      <div class="min" title="Temperatura minima giornaliera">
        {{data.dewpoint_c}}°
        <div class="label">&nbsp;min</div>
      </div>
      <div class="current" title="Temperatura attuale">{{data.temp_c}}°</div>
      <div class="max" title="Temperatura massima giornaliera">
        {{data.heat_index_c}}°
        <div class="label">&nbsp;max</div>
      </div>
    </div>
    <div class="info">
      <div title="Percentuale di umidità">{{data.relative_humidity}}<span class="unit"> %</span></div>
      <div title="Millimetri di pioggia">{{data.rain_day_in}}<span class="unit"> mm</span></div>
      <div title="Velocità vento in chilometri orari">{{data.wind_kt}}<span class="unit"> km/h</span></div>
    </div>
  </div>
</template>

<script lang="coffee">
import db from './database.coffee'

export default {

  data: () ->
    data: {}

  computed: 
    day_str: () -> @$store.state.time.now.toLocaleString('it-IT', {weekday: 'long'}).toUpperCase()
    day: () -> @$store.state.time.now.getDate()
    month: () -> @$store.state.time.now.toLocaleString('it-IT', {month: 'short'}).toUpperCase()
    time: () -> "#{@$store.state.time.now.getHours()}:#{@$store.state.time.now.getMinutes()}"

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
  width: 180px;
  background: #F5F5F5;
  box-shadow: var(--box-shadow);
  border-radius: 3px;
  padding: 10px;
}

.city {
  font-size: 13px;
  font-weight: bold;
  letter-spacing: 4px;
  text-align: center;
  color: #505050;
}
.time {
  margin-top: 5px;
  font-size: 10px;
  letter-spacing: 2px;
  color: rgb(169,169,169);
  text-align: center;
}
.temperature {
  display: flex;
  justify-content: space-around;
  align-items: center;
  margin-top: 5px;
  color: #505050;
}

.temperature .current {
  font-size: 30px;
}
.temperature .min, .temperature .max {
  position: relative;
}
.temperature .label {
  margin-top: -2px;
  font-size: 10px;
  color: rgb(169,169,169);
}

.info {
  display: flex;
  justify-content: space-around;
  margin-top: 10px;
  font-size: 13px;
  font-weight: 400;
  color: #505050;
}
.info .unit {
  font-size: 9px;
  color: rgb(169,169,169);
}
</style>
