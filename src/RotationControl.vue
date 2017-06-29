<template>
  <svg class="rotationcontrol">
    <g :transform="'translate(' + (radius+margin/2) + ',' + (radius+margin/2) + ')'">
      <g class="ring" :transform="'rotate(' + value + ')'">
        <circle class="external" :class="{dragging: dragging}" :r="radius"></circle>

        <g class="handle" :transform="'translate(0,' + (radius-margin-4) + ')'">
          <rect x="-4.5"></rect>
          <rect x="1.5"></rect>
        </g>
        <g class="handle" :transform="'translate(0,' + (-radius+margin+4) + ')'">
          <rect x="-4.5" y="-3"></rect>
          <rect x="1.5" y="-3"></rect>
        </g>
        <g class="handle" :transform="'translate(' + (radius-margin-4) + ', 0)'">
          <rect y="-4.5"></rect>
          <rect y="1.5"></rect>
        </g>
        <g class="handle" :transform="'translate(' + (-radius+margin+4) + ', 0)'">
          <rect y="-4.5" x="-3"></rect>
          <rect y="1.5" x="-3"></rect>
        </g>

        <g class="compass" @click="$emit('input', initial_value)">
          <circle class="back" r="20"></circle>
          <g transform="translate(-2, 0)">
            <path class="red" d="M -3,0 2,-15 7,0 z"/>
            <path class="white" d="M -3,0 2,15 7,0 z"/>
          </g>
          <circle class="top" r="4.8"></circle>
          
        </g>
      </g>
    </g>
  </svg>
</template>

<script lang="coffee">
import * as d3 from 'd3'

export default {
  props: ['value']

  data: () ->
    radius: 40
    margin: 5

    initial_value: @value
    dragging: false
    pinch_offset: null

  mounted: () ->
    @$el.style.setProperty '--width', "#{@radius*2 + @margin}px"
    @$el.style.setProperty '--height', "#{@radius*2 + @margin}px"

    drag = d3.drag()
      .on 'start', @dragstarted
      .on 'drag', @dragged
      .on 'end', @dragended
    
    d3.select(@$el).select('.ring')
      .call(drag)
  
  methods:
    dragstarted: (d) -> @dragging = true
    dragended: (d) -> 
      @dragging = false
      @pinch_offset = null
    
    dragged: (d) ->
      if not @pinch_offset?
        @pinch_offset = 180/Math.PI*Math.atan2(d3.event.y,d3.event.x)+180-@value
            
      # current angle in positive degrees
      angle = 180/Math.PI*Math.atan2(d3.event.y, d3.event.x)+180

      @$emit 'input', angle-@pinch_offset

}
</script>

<style scoped>
.rotationcontrol {
  position: absolute;
  bottom: 120px;
  right: 10px;
  width: var(--width);
  height: var(--height);
  z-index: 2;
  cursor: pointer;
}

.ring .external {
  fill: rgba(0,0,0,0.4);
  stroke: #FFF;
  stroke-width: 2.5px;
}

.handle rect {
  width: 3px;
  height: 3px;
  fill: #AAA;
}

.compass .red {
  fill: red;
}
.compass .white {
  width: 4px;
  height: 15px;
  fill: #FFF;
}
.compass .back {
  fill: #303030;
}
.compass .top {
  fill: #B5B5B5;
  stroke: #303030;
  stroke-width: 2;
}

.dragging {
  stroke: rgb(178, 178, 178) !important;
}
</style>
