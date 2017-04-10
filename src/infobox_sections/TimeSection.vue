<template>
  <svg v-if="start_date !== undefined && end_date !== undefined" class="time_section">
    <g>
      <rect class="bar" :x="scale_value(start_date)" y="40" :width="scale_value(end_date)-scale_value(start_date)"></rect>
      <text :x="scale_value(start_date)" y="32">{{start_date}}</text>
      <text :x="scale_value(end_date)" y="32">{{end_date}}</text>
    </g>
    
    <g>
      <rect class="bar reference" :x="scale_value(1538)" y="55" :width="scale_value(1612)-scale_value(1538)"></rect>
      <text :x="scale_value(1538)" y="85">1538</text>
      <text :x="scale_value(1612)" y="85">1612</text>
      <text :x="scale_value(1538)+(scale_value(1612)-scale_value(1538))/2" y="85">Clavius</text>
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
    scale: d3.scaleLinear().domain([1500, 1650]).range([0, 408])
    axis: d3.axisBottom().scale(@scale)

  mounted: () ->
    d3.select(@$el).append('g')#.call(@axis)

  computed:
    start_date: () -> kgl.parse(@config.start_date, @data)
    end_date: () -> kgl.parse(@config.end_date, @data)
    height: () -> if @height? then @height else undefined

  methods:
    scale_value: (value) -> @scale(value)

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
  height: 12px;
  fill: #B44646;
}

.reference {
  fill: steelblue;
}

text {
  font-size: 12px;
  text-anchor: middle;
}

</style>