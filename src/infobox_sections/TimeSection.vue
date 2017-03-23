<template>
  <svg v-if="start_date !== undefined && end_date !== undefined" class="time_section">
    <g :transform="get_translate()">
      <rect class="bar" :x="scale_value(start_date)" y="35" :width="scale_value(end_date)-scale_value(start_date)"></rect>
      <text :x="scale_value(start_date)" y="30">{{start_date}}</text>
      <text :x="scale_value(end_date)" y="30">{{end_date}}</text>
      <text class="years" :x="scale_value(start_date)+(scale_value(end_date)-scale_value(start_date))/2" y="46">{{end_date-start_date}}</text>
    </g>
    
    <g class="reference" v-if="data.id !== config.ref.id">
      <rect class="bar" :x="scale_value(ref.start_date)" y="57" :width="scale_value(ref.end_date)-scale_value(ref.start_date)"></rect>
      <text :x="scale_value(ref.start_date)" y="84">{{ref.start_date}}</text>
      <text :x="scale_value(ref.end_date)" y="84">{{ref.end_date}}</text>
      <text :x="scale_value(ref.start_date)+(scale_value(ref.end_date)-scale_value(ref.start_date))/2" y="84">Clavius</text>
      <text class="years" :x="scale_value(ref.start_date)+(scale_value(ref.end_date)-scale_value(ref.start_date))/2" y="67">{{ref.end_date-ref.start_date}}</text>
    </g>
  </svg>
</template>

<script lang="coffee">
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
    scale: d3.scaleLinear().domain(@config.domain).range(@config.range)

  computed:
    start_date: () -> kgl.parse(@config.start_date, @data)
    end_date: () -> kgl.parse(@config.end_date, @data)
    ref: () -> @config.ref
    height: () -> if @height? then @height else undefined

  methods:
    scale_value: (value) -> @scale(value)
    get_translate: () -> if @data.id isnt @config.ref.id then '' else 'translate(0,15)'

  components:
    titlesubsection: TitleSubSection
}
</script>

<style scoped>
.time_section {
  width: 100%;
  height: 100px;
}

.bar {
  height: 14px;
  fill: #B44646;
}
.reference .bar {
  fill: steelblue;
  opacity: 0.6;
}

text {
  font-size: 12px;
  text-anchor: middle;
}
.reference text {
  font-size: 11px;
}

.years {
  fill: white;
  font-weight: bold
}

</style>