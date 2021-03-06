<template>
  <div class="planetsection">
    <svg v-if="parent !== undefined && siblings !== undefined" :style="{'height': height + 'px'}">
      <g :transform="'translate(' + width/2 + ',' + height/2 + ')'">
        <a :href="'#/' + parent.id">
          <g class="primary">
              <circle r="15" cx="0" cy="0"></circle>
              <text class="halo" dy="0.34em">{{parent.label}}</text>
              <text dy="0.34em">{{parent.label}}</text>
          </g>
        </a>
        <g v-for="s in siblings"
          :class="{selected: space.id == s.id}">
          <ellipse
            class="orbit"
            :class="s.type"
            :rx="scale(+s.distance_from_primary_km)"
            :ry="scale(+s.distance_from_primary_km)*y_scaling"
          />
        </g>
        <g class="planet"
           v-for="s in siblings"
           v-if="s.id == space.id"
           :transform="'translate(' + get_x(s) + ',' + get_y(s) + ')'">
          <circle r="7"></circle>
          <text class="halo" y="-10">{{s.label.toUpperCase()}}</text>
          <text y="-10">{{s.label.toUpperCase()}}</text>
        </g>
      </g>
      <text class="footer" :x="width" :y="height">not to scale</text>
    </svg>
  </div>
</template>

<script lang="coffee">
import db from '../database.coffee'
import * as d3 from 'd3'

export default {
  data: () ->
    width: undefined
    height: undefined
    parent: undefined
    siblings: undefined
    y_scaling: 0.6

  computed:
    space: () -> @$store.state.selection.space
    scale: () ->
      d3.scalePow()
        .exponent(0.33)
        .domain [0, (d3.max @siblings, (d) -> +d.distance_from_primary_km )]
        .range [0, @width/2 - 8] # padding

  watch:
    space: (newSpace) -> @load_data(newSpace.id)

  mounted: () ->
    @width = @$el.getBoundingClientRect().width
    @load_data(@space.id)

  methods:
    get_x: (d) ->
      rx = @scale(+d.distance_from_primary_km)
      return rx * Math.sqrt(2) / 2
    get_y: (d) ->
      ry = @scale(+d.distance_from_primary_km) * @y_scaling
      return -ry * Math.sqrt(2) / 2
    load_data: (id) ->
      # avoid keeping old vis
      @parent = undefined
      @siblings = undefined

      db.query_family id, 'revolves_around', (obj) =>
        @parent = obj.parent
        @siblings = obj.siblings
        @height = @width * @y_scaling
}
</script>

<style scoped>
.planetsection {
  padding-top: 22px;
}
.planetsection svg {
  width: 100%;
}

.primary circle {
  fill: #AAA;
}
.primary text {
  text-anchor: middle;
  font-size: 14px;
}

.planet circle {
  stroke: var(--main-view-background);
  stroke-width: 3px;
}
.planet text {
  text-anchor: middle;
}
.halo {
  fill: var(--main-view-background);
  stroke: var(--main-view-background);
  stroke-opacity: 0.7;
  stroke-width: 5;
  stroke-linejoin: round;
  vector-effect: non-scaling-stroke;
}
.orbit {
  stroke: #000;
  stroke-width: 0.2px;
  fill: none;
}
.dwarf_planet.orbit {
  stroke-dasharray: 1 2;
}
.selected .orbit {
  stroke-width: 1.5px;
}


.footer {
  fill: #999;
  text-anchor: end;
  font-size: 11px;
}
</style>
