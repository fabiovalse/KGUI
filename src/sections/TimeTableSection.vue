<template>    
  <div class="timetable_section" v-if="data.timetables != undefined">
    <titlesubsection v-if="config.title !== undefined" :text="config.title"></titlesubsection>
    <svg>
      <g transform="translate(40,20)">
        <text class="label" v-for="(d,i) in days" :x="i*column_width + 13" y="0">{{d}}</text>
      </g>
      <g transform="translate(0,40)">
        <text class="label slot_label" v-for="(d,i) in time" x="0" :y="i*row_height">{{d+':00'}}</text>
      </g>
      <g transform="translate(40,35)">
        <g v-for="(t,i) in time.slice(0,-1)">
          <g v-for="(d,j) in days">
            <rect
              class="slot"
              :class="{open: check(j,t), close: !check(j,t)}"
              :x="j*column_width"
              :y="i*row_height"
            ></rect>
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
    timetable: () -> JSON.parse(@data.timetables)
    time: () -> 
      min = @timetable
        .filter (d) -> d.open?
        .map (d) -> d.open
        .reduce (acc, cur) -> Math.min acc, cur
      max = @timetable
        .filter (d) -> d.close?
        .map (d) -> d.close
        .reduce (acc, cur) -> Math.max acc, cur
      return [min...max]

  mounted: () ->
    document.querySelector('svg').style.height = @time.length*@row_height + 20

  data: () ->
    days: ["L", "M", "M", "G", "V", "S", "D"]
    row_height: 20
    column_width: 40

  methods:
    check: (i, hour) -> @timetable[i].open <= hour and @timetable[i].close >= hour

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

.label {
  font-weight: bold;
}
.slot_label {
  font-size: 12px;
  text-anchor: start;
}

.slot {
  width: 38px;
  height: 18px;
}
.slot.open {
  fill: #ccebc5;
}
.slot.close {
  fill: #fbb4ae;
}
</style>
