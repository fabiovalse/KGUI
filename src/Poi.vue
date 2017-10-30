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
        <circle v-if="is_open(data) != undefined" :class="{open: is_open(data), closed: !is_open(data)}" :r="mobile ? 320: 80"></circle>
        <circle class="background" :r="mobile ? 240: 60" cy="5">
          <title>{{data.label}}</title>
        </circle>
        <circle class="foreground" :r="mobile ? 240: 60"></circle>
      </g>

      <!-- Rect shaped POI -->
      <g v-if="data.shape == 'rect'">
        <rect class="background" :width="mobile ? 360 : 120" :height="mobile ? 360 : 120" :x="mobile ? -180 : -60" :y="mobile ? -173 : -55" :rx="mobile ? 45 : 15" :ry="mobile ? 45 : 15">
          <title>{{data.label}}</title>
        </rect>
        <rect class="foreground" :width="mobile ? 360 : 120" :height="mobile ? 360 : 120" :x="mobile ? -180 : -60" :y="mobile ? -180 : -60" :rx="mobile ? 45 : 15" :ry="mobile ? 45 : 15"></rect>
      </g>

      <!-- Content -->
      <foreignObject :x="mobile ? -145 : -50" :y="mobile? -135 : -35" :width="mobile ? 300 : 100" :height="mobile ? 300 : 100">
        <!-- Icon -->
        <i v-if="data.icon != undefined" :class="'icon icon-' + data.icon"></i>
        <!-- Text -->
        <div v-if="data.text != undefined" class="text">{{data.text}}</div>
      </foreignObject>
      
      <!-- External label -->
      <text class="background label" :class="{hidden: semantic_zoom()}" text-anchor="start" dy="0.35em" :x="mobile ? 360 : 80">{{data.label}}</text>
      <text class="foreground label" :class="{hidden: semantic_zoom()}" text-anchor="start" dy="0.35em" :x="mobile ? 360 : 80">{{data.label}}</text>
    </g>
    <title>{{data.label}}</title>
  </g>
</template>

<script lang="coffee">
export default {
  props: ['data']

  computed:
    target: () -> @$store.state.selection.target
    transform: () -> @$store.state.additional.transform
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
    get_scale: () -> "scale(#{if @transform? then 1/@transform.k else 1})"
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
  stroke-width: 3px;
}
.poi circle.foreground {
  fill: #FFF;
  stroke: #DDD;
  stroke-width: 3px;
}

.poi rect.background {
  fill: #777;
  stroke: #777;
  stroke-width: 3px;
}
.poi rect.foreground {
  fill: #FFF;
  stroke: #DDD;
  stroke-width: 3px;
}

.poi .icon {
  color: var(--circle-text-color);
  display: block;
  width: 100px;
  height: 100px;
  font-size: 70px;
  text-align: center;
}
.poi .text {
  font-size: 70px;
  font-weight: bold;
  text-align: center;
  margin-top: -5px;
  color: var(--circle-text-color);
}

.poi .label {
  font-size: 90px;
}
.poi .background.label {
  fill: FFF;
  stroke: FFF;
  opacity: 0.2;
  stroke-width: 12;
}
.poi .foreground.label {
  fill: #333;
}

.poi .hidden {
  display: none;
}

@media (max-width: 480px) {
  .poi .label {
    font-size: 240px;
  }

  .poi .icon {
    font-size: 280px;
  }

  .poi .text {
    font-size: 260px;
  }
}

</style>
