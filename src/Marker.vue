<template>
  <g
    v-if="data.x !== undefined && data.y !== undefined"
    class="marker"
    :transform="get_translate()"
    @click="select()"
  >
    <g :transform="get_scale()">
      <!-- Circle shaped Marker -->
      <g v-if="data.shape == 'circle'" :class="data.layer != undefined ? data.layer : ''">
        <circle v-if="is_open(data) != undefined" :class="{open: is_open(data), closed: !is_open(data)}" r="17"></circle>
        <circle class="background" r="12" cy="1">
          <title>{{data.label}}</title>
        </circle>
        <circle class="foreground" r="12"></circle>
        <markercounter v-if="data.has_counter" :data="data"></markercounter>
      </g>
      <!-- Rect shaped Marker -->
      <g v-if="data.shape == 'rect'" :class="data.layer != undefined ? data.layer : ''">
        <rect class="background" width="24" height="24" x="-12" y="-12" rx="3" ry="3">
          <title>{{data.label}}</title>
        </rect>
        <rect class="foreground" width="24" height="24" x="-12" y="-13" rx="3" ry="3"></rect>
      </g>

      <!-- Icon -->
      <foreignObject x="-10" y="-7" width="20" height="20" :class="data.layer != undefined ? data.layer : ''">
        <i v-if="data.icon != undefined" :class="'icon icon-' + data.icon"></i>
      </foreignObject>
      <!-- Text -->
      <g :class="data.layer != undefined ? data.layer : ''">
        <g v-if="data.text != undefined && semantic_zoom(data)" :class="{text: data.shape == undefined, text_on_shape: data.shape != undefined}">
          <text dy="0.35em">{{data.text}}</text>
        </g>
      </g>

      <!-- External label -->
      <g v-if="data.text == undefined && semantic_zoom(data)">
        <!-- Main label -->
        <text class="background label" text-anchor="start" dy="0.35em" :y="is_open(data) != undefined ? -7 : 0" x="17">{{data.label}}</text>
        <text class="foreground label" text-anchor="start" dy="0.35em" :y="is_open(data) != undefined ? -7 : 0" x="17">{{data.label}}</text>
        <!-- Sublabel -->
        <text v-if="is_open(data) != undefined" class="sublabel" x="17" y="13">{{is_open(data) ? 'Ora Aperto' : 'Ora Chiuso'}}</text>
      </g>
    </g>
    <title>{{data.label}}</title>
  </g>
</template>

<script lang="coffee">
import MarkerCounter from './MarkerCounter.vue'

export default {
  props: ['data', 'transform', 'transform_resize']

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

  methods:
    select: () -> @$store.dispatch 'select', {d: @data}
    get_translate: () -> "translate(#{@data.x}, #{@data.y})"
    get_scale: () -> "scale(#{if @transform? then 1/(@transform.k*@transform_resize.k) else 1})"
    
    semantic_zoom: (d) ->
      # Shape and text
      if d.shape? and d.text?
        true
      # External labels
      else if d.shape? and not(d.text?)
        @transform.k > 2.5
      # Only text (pois)
      else if d.template is 'poi' and not(d.shape?) and d.text?
        true
      # Only text (rooms)
      else if not(d.shape?) and d.text?
        @transform.k > 5
    is_open: (d) ->
      # Marker has a timetable
      if d.timetables?
        day_index = @now.getDay()
        day_index = if day_index is 0 then 6 else day_index-1

        # Closed
        if d.timetables[day_index].closed? or (@now < new Date("#{@today_date} #{d.timetables[day_index].open}") or @now > new Date("#{@today_date} #{d.timetables[day_index].close}"))
          return false
        # Open
        else
          return true
      else
        return undefined

  components:
    markercounter: MarkerCounter

}
</script>

<style scoped>
.marker {
  cursor: pointer;
}

.marker .open {
  fill: #ccebc5;
}
.marker .closed {
  fill: #fbb4ae;
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

.marker .label {
  font-size: 16px;
}
.marker .background.label {
  fill: #FFF;
  stroke: #FFF;
  opacity: 0.4;
  stroke-width: 3;
}
.marker .foreground.label {
  fill: #333;
}
.marker .sublabel {
  font-size: 12.5px;
  fill: #404040;
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
