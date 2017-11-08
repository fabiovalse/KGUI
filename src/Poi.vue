<template>
  <g
    v-if="data.x !== undefined && data.y !== undefined"
    class="poi"
    :transform="get_translate()"
    @click="select()"
  >
    <g :transform="get_scale()">
      <!-- Circle shaped POI -->
      <g v-if="data.shape == 'circle'">
        <circle v-if="is_open(data) != undefined" :class="{open: is_open(data), closed: !is_open(data)}" r="20"></circle>
        <circle class="background" r="15" cy="1">
          <title>{{data.label}}</title>
        </circle>
        <circle class="foreground" r="15"></circle>
        <markercounter v-if="data.has_counter" :data="data"></markercounter>
      </g>

      <!-- Rect shaped POI -->
      <g v-if="data.shape == 'rect'">
        <rect class="background" width="30" height="30" x="-15" y="-13" rx="3" ry="3">
          <title>{{data.label}}</title>
        </rect>
        <rect class="foreground" width="30" height="30" x="-15" y="-15" rx="3" ry="3"></rect>
      </g>

      <!-- Content -->
      <foreignObject x="-12.5" y="-8.5" width="25" height="25">
        <!-- Icon -->
        <i v-if="data.icon != undefined" :class="'icon icon-' + data.icon"></i>
        <!-- Text -->
        <div v-if="data.text != undefined" class="text">{{data.text}}</div>
      </foreignObject>
      
      <!-- External label -->
      <g>
        <text class="background label" :class="{hidden: semantic_zoom()}" text-anchor="start" dy="0.35em" x="20">{{data.label}}</text>
        <text class="foreground label" :class="{hidden: semantic_zoom()}" text-anchor="start" dy="0.35em" x="20">{{data.label}}</text>
        <text
          v-if="is_open(data) != undefined"
          class="sublabel"
          :class="{hidden: semantic_zoom()}"
          x="20"
          y="23"
        >
          {{is_open(data) ? 'Ora Aperto' : 'Ora Chiuso'}}
        </text>
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
    semantic_zoom: () -> @transform.k < 2.5
    is_open: (d) ->
      # Poi has a timetable
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
.poi {
  cursor: pointer;
  --circle-text-color: #7b5b5b;
}

.poi .open {
  fill: #ccebc5;
}
.poi .closed {
  fill: #fbb4ae;
}

.poi circle.background {
  fill: #777;
  stroke: #777;
  stroke-width: 1px;
}
.poi circle.foreground {
  fill: #FFF;
  stroke: #DDD;
  stroke-width: 1px;
}

.poi rect.background {
  fill: #777;
  stroke: #777;
  stroke-width: 1px;
}
.poi rect.foreground {
  fill: #FFF;
  stroke: #DDD;
  stroke-width: 1px;
}

.poi .icon {
  color: var(--circle-text-color);
  display: block;
  width: 25px;
  height: 25px;
  font-size: 18px;
  text-align: center;
}
.poi .text {
  font-size: 18px;
  font-weight: bold;
  text-align: center;
  margin-top: -1px;
  color: var(--circle-text-color);
}

.poi .label {
  font-size: 20px;
}
.poi .background.label {
  fill: #FFF;
  stroke: #FFF;
  opacity: 0.4;
  stroke-width: 3;
}
.poi .foreground.label {
  fill: #333;
}
.poi .sublabel {
  font-size: 15px;
  fill: #404040;
}

.poi .hidden {
  display: none;
}

</style>
