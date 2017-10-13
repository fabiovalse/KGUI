<template>    
  <div v-if="data.timetables != undefined" class="timetable_section">
    <titlesubsection v-if="config.title !== undefined" :text="config.title"></titlesubsection>
    <svg>
      <!-- labels -->
      <g class="days" :transform="'translate('+left_margin+','+top_margin+')'">
        <circle
          :cx="today*column_width + 13 + 6"
          cy="-0.5"
          r="12"
        ></circle>
        <text class="label" v-for="(d,i) in days" 
          :x="i*column_width + 13"
          y="0"
          dy="0.35em"
          :class="{selected: i==today}"
        >
          {{d[0]}}
          <title>{{d}}</title>
        </text>
      </g>
      <g class="hours" :transform="'translate(0,'+top_margin*2+')'">
        <text class="label" v-for="(d,i) in time"
          x="30"
          :y="i*tick_length"
          dy="0.35em"
        >
          {{d+':00'}}
        </text>
      </g>

      <!-- axis -->
      <g class="axis" :transform="'translate(38,'+top_margin*2+')'">
        <line
          x1="0"
          y1="0"
          x2="0"
          :y2="time.length*row_height"
        ></line>
        <line class="tick"
          v-for="(d,i) in time"
          x1="-5"
          :y1="i*tick_length"
          x2="1"
          :y2="i*tick_length"
        ></line>
      </g>

      <!-- time slots -->
      <g transform="translate(40,35)">
        <g v-for="(h,i) in time.slice(0,-1)">
          <g v-for="(d,j) in timetable">
            <g v-if="check_half(d,h)">
              <rect
                class="slot"
                :class="{open: check_open(d,h), close: !check_open(d,h)}"
                :x="j*column_width"
                :y="i*tick_length"
                :style="{height: (tick_length-2)/2}"
              ></rect>
              <rect
                class="slot"
                :class="{open: check_open(d,h+0.3), close: !check_open(d,h+0.3)}"
                :x="j*column_width"
                :y="i*tick_length + (tick_length-2)/2"
                :style="{height: (tick_length-2)/2}"
              ></rect>
            </g>
            <g v-else>
              <rect
                class="slot"
                :class="{open: check_open(d,h), close: !check_open(d,h)}"
                :x="j*column_width"
                :y="i*tick_length"
                :style="{height: tick_length-2}"
              ></rect>
            </g>
          </g>
        </g>
      </g>
    </svg>
  </div>
</template>

<script lang="coffee">
import TitleSubSection from './TitleSubSection.vue'

export default {
  props:
    data:
      type: Object
      required: true
    config:
      type: Object
      required: true

  computed:
    timetable: () -> 
      # FIXME: Once migration to Arango is terminated this should be only
      #        if @data.timetables? then @data.timetables else []
      if @data.timetables?
        if typeof(@data.timetablesthen) is 'string'
          return JSON.parse(@data.timetables)
        else
          return @data.timetables
      else
        return []
    time: () -> 
      min = @timetable
        .filter (d) -> d.open?
        .map (d) -> d.open
        .reduce (acc, cur) -> Math.min acc, cur
      max = @timetable
        .filter (d) -> d.close?
        .map (d) -> d.close
        .reduce (acc, cur) -> Math.max acc, cur
      return [Math.floor(min)..Math.ceil(max)]
    tick_length: () -> @time.length*@row_height/(@time.length-1)
    today: () -> 
      day = new Date().getDay()
      return if day is 0 then 6 else day-1

  watch:
    data: () -> @init()

  mounted: () -> 
    @init()

  data: () ->
    days: ["Lunedì", "Martedì", "Mercoledì", "Giovedì", "Venerdì", "Sabato", "Domenica"]
    top_margin: 17
    left_margin: 40
    row_height: 14
    column_width: 40

  methods:
    init: () -> 
      if @data.timetables?
        @$el.querySelector('svg').style.height = @time.length*@row_height + 40
    check_open: (d, t) -> d.open <= t and d.close > t
    check_half: (d, t) -> 
      return (d.open%1 != 0 and (t+1)-d.open < 1) or (d.close%1 != 0 and d.close - t < 1)

  components:
    titlesubsection: TitleSubSection
}
</script>

<style scoped>
.timetable_section {
  padding: 10px 24px 10px 24px;
}
svg {
  width: 100%;
  font-family: sans-serif;
}

/* labels
*/
.days .label, .hours .label {
  font-weight: bold;
}
.hours .label {
  font-size: 12px;
  text-anchor: end;
}

.days circle {
  fill: #404040;
}
.selected {
  fill: #FFF;
}

/* axis
*/
.axis line {
  stroke: #000;
  shape-rendering: crispEdges;
}
.axis .tick {
  shape-rendering: crispEdges;
}

/* slots
*/
.slot {
  width: 38px;
}
.slot.open {
  fill: #ccebc5;
}
.slot.close {
  fill: #fbb4ae;
}


</style>
