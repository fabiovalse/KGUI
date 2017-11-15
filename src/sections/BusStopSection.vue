<template>
  <div class="bus_stop_section" v-if="data._key == 'bus@area.cnr.it'">
    <titlesubsection text="Orario autobus"></titlesubsection>
    <div v-for="item in timetable" class="bus" :class="get_status_class(item)">
      <div class="name">{{item.bus_name.replace('Linea ', '')}}</div>
      <div class="end_station">{{item.end_station}}</div>
      <div class="time">{{item.time.slice(0,-3)}}</div>
    </div>
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
    timetable: []

  computed:
    now: () -> @$store.state.time.now

  mounted: () ->
    if @data._key == 'bus@area.cnr.it'
      query = "FOR doc IN bus SORT doc.time RETURN doc"

      cb = (data) =>
        if data?
          @timetable = data

      db.execute_arango query, cb, null, {}

  methods:
    get_status_class: (item) ->
      date = new Date("#{@now.getMonth()+1}/#{@now.getDate()}/#{@now.getFullYear()} #{item.time}")
      diff = (date - @now) / (60*1000)
      
      if diff > 0 and diff <= 10
        return 'coming_soon'
      else if diff < 0
        return 'past'
      else
        return 'future'

  components:
    titlesubsection: TitleSubSection
}
</script>

<style scoped>
.bus_stop_section {
  padding: 10px 24px 10px 24px;
}

.bus {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 12px;
  margin-bottom: 15px;
  border-right: 3px solid #FFF;
}
.bus .name {
  font-weight: bold;
  width: 70px;
  height: 20px;
  border: 1px solid black;
  text-align: center;
  line-height: 22px;
}
.bus .end_station {
  width: 200px;
  flex-wrap: wrap;
  padding-left: 10px;
}
.bus .time {
  width: 40px; 
  font-size: 15px;
}

.bus.past {
  display: none;
  color: #DDD;
}
.bus.past .name {
  border: 1px solid #DDD;
}

.bus.coming_soon {
  background: #ccebc5;
  border-right: 3px solid #a5e297;
}
</style>