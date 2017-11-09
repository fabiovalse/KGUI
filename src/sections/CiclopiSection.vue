<template>
  <div class="ciclopi_section" v-if="data._key == 'ciclopi@area.cnr.it'">
    <titlesubsection text="Stato Stazione"></titlesubsection>
    <div class="row" v-if="free_bikes.length > 0">
      <div class="bike_places">
        <div class="bike_place free" v-for="d in free_bikes">
          <i v-if="d == 1" class="icon-bicycle"></i>
        </div>
      </div>
      <div class="label">{{free_bikes.length}} Biciclette disponibili</div>
    </div>
    <div class="row" v-if="empty_slots.length > 0">
      <div class="bike_places">
        <div class="bike_place empty" v-for="d in empty_slots">
          <i v-if="d == 1" class="icon-bicycle"></i>
        </div>
      </div>
      <div class="label">{{empty_slots.length}} Stalli vuoti</div>
    </div>
    <div class="row" v-if="unavailable_slots.length > 0">
      <div class="bike_places">
        <div class="bike_place unavailable" v-for="d in unavailable_slots">
          <i v-if="d == 1" class="icon-bicycle"></i>
        </div>
      </div>
      <div class="label">{{unavailable_slots.length}} Stalli guasti</div>
    </div>
    <br>
    <titlesubsection text="Disponibilità oraria"></titlesubsection>
    <svg class="popular_times">
      <g transform="translate(2,0)">
        <g v-for="(d,i) in free_bikes_hour_average">
          <rect class="bar" :x="d.hour*bar_width" :y="max_bar_height-bar_scale(d.free_bikes)" :width="bar_width" :height="bar_scale(d.free_bikes)"></rect>
        </g>
        <g>
          <line class="axis" x1="0" y1="100" :x2="axis_length" y2="100"></line>
          
          <g v-for="(tick,i) in ticks" class="tick">
            <line :x1="i*bar_width" y1="100" :x2="i*bar_width" :y2="i%3 == 0 ? 106 : 103"></line>
            <text v-if="i%3 == 0" :x="i*bar_width" y="118">{{i}}</text>
          </g>
        </g>
      </g>
    </svg>
  </div>
</template>

<script lang="coffee">
import db from '../database.coffee'
import config from '../config.coffee'
import kgl from './kgl.coffee'
import TitleSubSection from './TitleSubSection.vue'

export default {
  props:
    data:
      type: Object
      required: true
    config:
      type: Object
      required: true

  data: () ->
    free_bikes: []
    empty_slots: []
    unavailable_slots: []
    free_bikes_hour_average: []
    axis_length: 330
    ticks: [0..24]
    max_bar_height: 100

  computed: 
    bar_width: () -> @axis_length/(@ticks.length-1)

  watch:
    free_bikes_hour_average: (value) ->
      @bar_scale = d3.scaleLinear()
        .range [0,@max_bar_height]
        .domain [0, d3.max value.map (d) -> d.free_bikes]

  mounted: () ->
    if @data._key == 'ciclopi@area.cnr.it'
      # Bike status
      _this = @
      fetch('http://wafi.iit.cnr.it:8529/_db/campusmap/_api/simple/all', {
        method: "PUT"
        body: JSON.stringify({"collection": "ciclopi"})
        headers: {Authorization: config.db.auth}
      })
      .then (response) -> response.json()
      .then (data) ->
        data = data.result[0]
        _this.free_bikes = Array.from(Array(data.free_bikes).keys()).map (d) -> 1
        _this.empty_slots = Array.from(Array(data.empty_slots).keys()).map (d) -> 0
        _this.unavailable_slots = Array.from(Array(data.unavailable_slots).keys()).map (d) -> 2

      # Average bike availability
      query = """
      FOR doc IN ciclopi_history
      COLLECT
        hour = DATE_HOUR(doc._start)
      AGGREGATE
        free_bikes = AVERAGE(doc.free_bikes)
      RETURN {hour, free_bikes}
      """

      cb = (data) =>
        if data?
          @free_bikes_hour_average = data

      db.execute_arango query, cb, null, {}

  components:
    titlesubsection: TitleSubSection
}
</script>

<style scoped>
.ciclopi_section {
  padding: 10px 24px 10px 24px;
}

.row {
  margin-bottom: 15px;
}
.row .label {
  font-size: 13px;
  color: rgba(0,0,0,0.54);
}
.row .bike_places {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
  flex-grow: 1;
}
.row .bike_places .bike_place {
  width: 22px;
  height: 30px;
  margin-right: 2px;
  text-align: center;
  line-height: 33px;
}
.row .bike_places .bike_place.free {
  background: #ccebc5;
}
.row .bike_places .bike_place.empty {
  background: #f2f2f2;
}
.row .bike_places .bike_place.unavailable {
  background: #fbb4ae;
}

.popular_times {
  width: 100%;
  height: 120px;
}
.popular_times .bar {
  stroke: #FFF;
  stroke-width: 1.5px;
  fill: steelblue;
}
.popular_times .tick line {
  stroke: rgba(0,0,0,0.54);
  stroke-width: 1px;
}
.popular_times .tick text {
  fill: rgba(0,0,0,0.54);
  font-size: 10px;
  text-anchor: middle;
}
.popular_times .axis {
  stroke: rgba(0,0,0,0.54);
  stroke-width: 0.5px;
}

</style>