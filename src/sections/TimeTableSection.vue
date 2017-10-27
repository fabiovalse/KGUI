<template>    
  <div v-if="data.timetables != undefined" class="timetable_section">
    <titlesubsection 
      v-if="config.title !== undefined"
      :text="config.title+(is_now_open() ? ' - (Ora aperto)' : ' - (Ora chiuso)')"
    ></titlesubsection>
    
    <svg :style="{height: timeslots.length*row_height+40}">
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
        <text class="label" v-for="(d,i) in timeslots"
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
          :y2="timeslots.length*row_height"
        ></line>
        <line class="tick"
          v-for="(d,i) in timeslots"
          x1="-5"
          :y1="i*tick_length"
          x2="1"
          :y2="i*tick_length"
        ></line>
      </g>

      <!-- time slots -->
      <g transform="translate(40,35)">
        <g v-for="(h,i) in timeslots.slice(0,-1)">
          <g v-for="(d,j) in timetable">
            <g v-if="check_half(d,h)">
              <rect
                class="slot"
                :class="{open: is_slot_open(d,h,0), close: !is_slot_open(d,h,0)}"
                :x="j*column_width"
                :y="i*tick_length"
                :style="{height: (tick_length-2)/2}"
              ></rect>
              <rect
                class="slot"
                :class="{open: is_slot_open(d,h,30), close: !is_slot_open(d,h,30)}"
                :x="j*column_width"
                :y="i*tick_length + (tick_length-2)/2"
                :style="{height: (tick_length-2)/2}"
              ></rect>
            </g>
            <g v-else>
              <rect
                class="slot"
                :class="{open: is_slot_open(d,h), close: !is_slot_open(d,h)}"
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
    timetable: () -> if @data.timetables? then @data.timetables else []
    
    timeslots: () -> 
      min = @timetable
        .filter (d) -> d.open?
        .map (d) -> d.open
        .reduce (acc, cur) => 
          a = new Date("#{@today_date} #{acc}")
          b = new Date("#{@today_date} #{cur}")
          return if a < b then a else b

      max = @timetable
        .filter (d) -> d.close?
        .map (d) -> d.close
        .reduce (acc, cur) =>
          if Date.parse(acc) is NaN
            a = new Date("#{@today_date} #{acc}")

          a = acc
          b = new Date("#{@today_date} #{cur}")
          
          return if a > b then a else b

      return [min.getHours()..(if max.getMinutes() is 0 then max.getHours() else max.getHours()+1)]
    
    now: () -> @$store.state.time.now

    today: () ->
      day = new Date().getDay()
      return if day is 0 then 6 else day-1

    today_date: () -> 
      today = new Date()
      return "#{today.getMonth()+1}/#{today.getDate()}/#{today.getFullYear()}"

    tick_length: () -> @timeslots.length*@row_height/(@timeslots.length-1)

  data: () ->
    days: ["Lunedì", "Martedì", "Mercoledì", "Giovedì", "Venerdì", "Sabato", "Domenica"]
    top_margin: 17
    left_margin: 40
    row_height: 14
    column_width: 40

  methods:
    is_now_open: () ->
      day = new Date().getDay()
      day = if day is 0 then 6 else day-1

      return new Date("#{@today_date} #{@data.timetables[day].open}") <= new Date(@now) <= new Date("#{@today_date} #{@data.timetables[day].close}")

    is_slot_open: (d, h, m) -> 
      open = new Date("#{@today_date} #{d.open}")
      close = new Date("#{@today_date} #{d.close}")
      bound = new Date("#{@today_date} #{h}:#{m}")

      if m?
        return open <= bound and close > bound
      else
        return open.getHours() <= h and close.getHours() > h

    check_half: (d, h) -> 
      open = new Date("#{@today_date} #{d.open}")
      close = new Date("#{@today_date} #{d.close}")

      return (open.getHours() is h and open.getMinutes() isnt 0) or (close.getHours() is h and close.getMinutes() isnt 0)

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
