<template>
  <g
    v-if="data.x !== undefined && data.y !== undefined && visible"
    class="marker"
    :transform="get_translate()"
    @click="select()"
  >
    <g :transform="get_scale()">
      <!-- Circle shaped Marker -->
      <g
        v-if="data.shape == 'circle'"
        :class="data.layer != undefined ? data.layer : ''"
      >
        <circle class="background" :r="radius" cy="1">
          <title>{{data.label}}</title>
        </circle>
        <circle class="foreground" :r="radius"></circle>
      </g>
      <!-- Rect shaped Marker -->
      <g
        v-if="data.shape == 'rect'"
        :class="data.layer != undefined ? data.layer : ''"
      >
        <rect class="background" :width="side" :height="side" :x="-side/2" :y="-side/2" rx="3" ry="3">
          <title>{{data.label}}</title>
        </rect>
        <rect class="foreground" :width="side" :height="side" :x="-side/2" :y="-side/2-1" rx="3" ry="3"></rect>
      </g>

      <!-- Icon -->
      <foreignObject x="-10" y="-7" width="20" height="20" :class="data.layer != undefined ? data.layer : ''">
        <i v-if="data.icon != undefined" :class="'icon icon-' + data.icon"></i>
      </foreignObject>
      <!-- Text -->
      <g :class="data.layer != undefined ? data.layer : ''">
        <g v-if="data.text != undefined" :class="{text: data.shape == undefined, text_on_shape: data.shape != undefined}">
          <text dy="0.35em">{{data.text}}</text>
        </g>
      </g>

      <!-- External label -->
      <g v-if="data.text == undefined && label_visible">
        <!-- Main label -->
        <maplabel
          :text="data.label"
          :transform="'translate(17,' + (status != undefined ? -7 : 0) + ')'"
        ></maplabel>
        <!-- Sublabel -->
        <maplabel
          v-if="status != undefined"
          :status="status"
          cls="sublabel"
          transform="translate(17, 13)"
        ></maplabel>
      </g>

      <!-- Marker Counter -->
      <markercounter v-if="data.has_counter" :data="data"></markercounter>

      <!-- Marker Status -->
      <circle
        class="status"
        :class="status.id"
        v-if="status != undefined"
        r="6"
        :cx="10"
        :cy="8"
      ></circle>
    </g>
    <title>{{data.label}}</title>
  </g>
</template>

<script lang="coffee">
import Label from './Label.vue'
import MarkerCounter from './MarkerCounter.vue'

export default {
  props: ['data', 'transform', 'transform_resize']

  data: () ->
    side: 24
    radius: 12

  computed:
    target: () -> @$store.state.selection.target
    now: () -> @$store.state.time.now
    today_date: () -> 
      if @data.timetables?
        today = new Date()
        return "#{today.getMonth()+1}/#{today.getDate()}/#{today.getFullYear()}"
      else
        return undefined
    mobile: () -> @$mq.below('480px')
    status: () ->
      # Marker has a timetable
      if @data.timetables?
        day_index = @now.getDay()
        day_index = if day_index is 0 then 6 else day_index-1

        opening_time = new Date("#{@today_date} #{@data.timetables[day_index].open}")
        closing_time = new Date("#{@today_date} #{@data.timetables[day_index].close}")

        # Closing soon
        diff = (closing_time - @now) / (36*100000)
        if 0 < diff <= 0.5
          return {id: 'closing_soon', label: 'Chiude tra '+Math.round((closing_time - @now) / (60*1000))+' minuti'}

        # Opening soon
        diff = (opening_time - @now) / (36*100000)
        if 0 < diff <= 0.5
          return {id: 'opening_soon', label: 'Apre tra '+Math.round((opening_time - @now) / (60*1000))+' minuti'}

        # Closed
        if @data.timetables[day_index].closed? or not(opening_time < @now < closing_time)
          return {id: 'closed', label: 'Ora chiuso'}
        # Open
        else
          return {id: 'open', label: 'Ora aperto'}
      else
        return undefined
    visible: () ->
      if @data.template is 'room' # FIXME
        @transform.k > 8
      else
        @transform.k > 1
    label_visible: () ->
      @transform.k > 4

  methods:
    select: () ->
      if @data.layer is 'directions'
        @$emit 'changed', if @data.floorswitch is 'up' then @data.floor+1 else @data.floor-1
      else
        @$store.dispatch 'select', {d: @data}
    get_translate: () -> "translate(#{@data.x}, #{@data.y})"
    get_scale: () -> "scale(#{if @transform? then 1/(@transform.k*@transform_resize.k) else 1})"

  components:
    markercounter: MarkerCounter
    maplabel: Label

}
</script>

<style scoped>
.marker {
  cursor: pointer;
}

.marker .status {
  stroke: #FFF;
  stroke-opacity: 0.5;
}
.marker .open.status {
  fill: #378a24;
}
.marker .closed.status {
  fill: #b7382e;
}
.marker .closing_soon.status {
  fill: #c18f00;
}
.marker .opening_soon.status {
  fill: #b7382e;
}


.marker circle.background {
  fill: #777;
  stroke: #777;
  stroke-width: 1px;
}
.marker circle.foreground {
  fill: #7b5b5b;
  stroke: #FFF;
  stroke-width: 1.5px;
}

.marker rect.background {
  fill: #777;
  stroke: #777;
  stroke-width: 1px;
}
.marker rect.foreground {
  fill: #7b5b5b;
  stroke: #FFF;
  stroke-width: 1.5px;
}

.marker .icon {
  color: #FFF;
  display: block;
  width: 20px;
  height: 20px;
  font-size: 14px;
  text-align: center;
}
.marker .text {
  font-size: 18px;
  font-weight: bold;
  fill: rgba(0,0,0,0.45);
  text-anchor: middle;
}
.marker .text_on_shape {
  fill: #FFF;
  font-weight: bold;
  text-anchor: middle;
}

/* Directions class
*/
.marker .directions .icon {
  color: #000;
  background: #FFF;
  font-size: 20px;
  border-radius: 10px;
}

/* Specific marker classes
*/
.marker .food_and_drinks .icon, .marker .mobility .icon, .marker .emergency .icon, .marker .commercial .icon {
  color: #FFF;
}
.marker .food_and_drinks .foreground, .marker .mobility .foreground, .marker .emergency .foreground, .marker .commercial .foreground {
  stroke: #FFF;
  stroke-width: 1.5px;
}

.marker .food_and_drinks .foreground {
  fill: #F57F17;
}
.marker .mobility .foreground {
  fill: #00B0FF;
}
.marker .emergency .foreground {
  fill: #DB4437;
}
.marker .commercial .foreground {
  fill: #6b7DE3;
}

.marker .entrance .foreground {
  fill: #f5f5f5;
  stroke: #0d5784; 
}
.marker .entrance > * {
  fill: #0d5784;
}
</style>
