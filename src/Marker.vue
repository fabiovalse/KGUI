<template>
  <g
    v-if="data.x !== undefined && data.y !== undefined"
    class="marker"
    :transform="get_translate()"
    @click="select()"
  >
    <g :transform="get_scale()">
      <!-- Circle shaped Marker -->
      <g v-if="data.shape == 'circle'">
        <circle v-if="is_open(data) != undefined" :class="{open: is_open(data), closed: !is_open(data)}" r="20"></circle>
        <circle class="background" r="15" cy="1">
          <title>{{data.label}}</title>
        </circle>
        <circle class="foreground" r="15"></circle>
        <markercounter v-if="data.has_counter" :data="data"></markercounter>
      </g>
      <!-- Rect shaped Marker -->
      <g v-if="data.shape == 'rect'">
        <rect class="background" width="30" height="30" x="-15" y="-13" rx="3" ry="3">
          <title>{{data.label}}</title>
        </rect>
        <rect class="foreground" width="30" height="30" x="-15" y="-15" rx="3" ry="3"></rect>
      </g>

      <!-- Icon -->
      <foreignObject x="-12.5" y="-8.5" width="25" height="25">
        <i v-if="data.icon != undefined" :class="'icon icon-' + data.icon"></i>
      </foreignObject>
      <!-- Text -->
      <g v-if="data.text != undefined && semantic_zoom(data)" :class="{text: data.shape == undefined, text_on_shape: data.shape != undefined}">
        <text dy="0.35em">{{data.text}}</text>
      </g>
      
      <!-- External label -->
      <g v-if="data.text == undefined && semantic_zoom(data)">
        <!-- Main label -->
        <text class="background label" text-anchor="start" dy="0.35em" :y="is_open(data) != undefined ? -7 : 0" x="22">{{data.label}}</text>
        <text class="foreground label" text-anchor="start" dy="0.35em" :y="is_open(data) != undefined ? -7 : 0" x="22">{{data.label}}</text>
        <!-- Sublabel -->
        <text v-if="is_open(data) != undefined" class="sublabel" x="22" y="16">{{is_open(data) ? 'Ora Aperto' : 'Ora Chiuso'}}</text>
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
  --shape-content-color: #7b5b5b;
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
  fill: #FFF;
  stroke: #DDD;
  stroke-width: 1px;
}

.marker rect.background {
  fill: #777;
  stroke: #777;
  stroke-width: 1px;
}
.marker rect.foreground {
  fill: #FFF;
  stroke: #DDD;
  stroke-width: 1px;
}

.marker .icon {
  color: var(--shape-content-color);
  display: block;
  width: 25px;
  height: 25px;
  font-size: 18px;
  text-align: center;
}
.marker .text {
  font-size: 18px;
  font-weight: bold;
  fill: rgba(0,0,0,0.45);
  text-anchor: middle;
}
.marker .text_on_shape {
  fill: var(--shape-content-color);
  font-weight: bold;
  text-anchor: middle;
}

.marker .label {
  font-size: 20px;
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
  font-size: 15px;
  fill: #404040;
}

</style>
