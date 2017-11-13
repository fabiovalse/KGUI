<template>
  <div v-if="rooms.indexOf(data._key) >= 0" class="calendar_section">
    <titlesubsection v-if="config.title !== undefined" :text="config.title"></titlesubsection>
    <div v-for="event in events"
      class="event"
      :class="check_time(event)"
    >
      <div class="date">
        <div class="month">{{(new Date().toLocaleString('it-it', {month: "short"})).toUpperCase()}}</div>  
        <div class="day">
          {{new Date(event.day).getDate()}}
        </div>
      </div>
      <a class="info" :href="event.link" target="_blank">
        <div class="label">{{event.label}}</div>
        <div class="hours">@{{event.from}} - {{event.to}}</div>
      </a>
    </div>
  </div>
</template>

<script lang="coffee">
import db from '../database.coffee'
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
    events: []
    rooms: ["Aula40@area.cnr.it", "Aula28@area.cnr.it", "Aula30@area.cnr.it", "Aula29@area.cnr.it", "Aula27@area.cnr.it", "auditorium@area.cnr.it"]

  mounted: () ->
    if @data._key in @rooms
      query = """
      LET today = DATE_NOW()
      FOR doc IN events
        FILTER doc.room == @key AND DATE_YEAR(today) == DATE_YEAR(doc.day) AND DATE_MONTH(today) == DATE_MONTH(doc.day)
        SORT doc.day
        RETURN doc
      """

      cb = (data) =>
        if data?
          @events = data

      db.execute_arango query, cb, null, {key: @data._key}

  methods:
    check_time: (event) ->
      today = new Date().getDate()
      event_date = new Date(event.day).getDate()
      
      if event_date < today
        return 'past'
      else if event_date > today
        return 'future'
      else
        return 'today'

  components:
    titlesubsection: TitleSubSection

}
</script>

<style scoped>
.calendar_section {
  padding: 20px 24px 20px 24px;
  --event-width: 332px;
  --info-width: 285px;
}

.event {
  display: flex;
  padding-top: 8px;
  padding-bottom: 8px;
}

.event .date {
  width: calc(var(--event-width) - var(--info-width));
  text-align: center;
  color: steelblue;
}
.event.past .date {
  color: lightsteelblue;
}
.event .date .day {
  font-weight: bold;
  font-size: 25px;
  border: 2px solid steelblue;
  height: 28px;
}
.event.past .date .day {
  border: 2px solid lightsteelblue;
}
.event .date .month {
  font-size: 15px;
  background: steelblue;
  color: #FFF;
  height: 15px;
}
.event.past .date .month {
  background: lightsteelblue;
}

.event .info {
  flex-grow: 1;
  width: var(--info-width);
  margin-left: 12px;
  padding: 3px;
  color: #000;
  text-decoration: none;
}
.event .info:hover {
  background: #F8F8F8;
  cursor: pointer;
}
.event .info .label {
  font-weight: bold;
  font-size: 13px;
}
.event .info .hours {
  color: #808080;
  font-size: 13px;
}
.event.today .info {
  background: #ccebc5;
  border-right: 3px solid #a5e297;
}
.event.past .info .label, .event.past .info .hours {
  color: #DDD;
}
</style>