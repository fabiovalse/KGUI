<template>
  <div class="planetsection">
    <svg v-if="parent !== undefined" :style="{'height': height + 'px'}">
      <g :transform="'translate(' + width + ',' + height/2 + ')'">
        <a :href="'#/' + parent.id">
          <g class="primary">
              <circle r="12" cx="0" cy="0"></circle>
              <text dy="0.34em">{{parent.label}}</text>
          </g>
        </a>
        <g v-for="(s,i) in siblings">
          <ellipse
            class="orbit"
            :class="{selected: space.id == s.id}"
            :rx="(i+d_from_origin)*x_factor"
            :ry="(i+d_from_origin)*y_factor"
          />
        </g>
        <g v-for="(s,i) in siblings" v-if="s.id == space.id" :transform="'translate(' + get_x(i) + ',' + get_y(i) + ')'">
          <circle class="planet" r="7"></circle>
          <text class="halo" x="10" y="-10" dy="0.34em">{{s.label.toUpperCase()}}</text>
          <text x="10" y="-10" dy="0.34em">{{s.label.toUpperCase()}}</text>
        </g>
      </g>
    </svg>
  </div>
</template>

<script lang="coffee">
import db from '../database.coffee'

export default {
  data: () ->
    width: 169
    height: 0
    parent: undefined
    siblings: []
    x_factor: 11
    y_factor: 5
    d_from_origin: 3

  computed:
    space: () -> @$store.state.selection.space

  watch:
    space: (newSpace) -> @load_data(newSpace.id)

  mounted: () -> @load_data(@space.id)

  methods:
    get_x: (i) ->
      rx = (i+@d_from_origin) * @x_factor
      return rx * Math.sqrt(2) / 2
    get_y: (i) ->
      ry = (i+@d_from_origin) * @y_factor
      return -ry * Math.sqrt(2) / 2
    load_data: (id) ->
      db.query_family id, 'revolves_around', (obj) => 
        @parent = obj.parent
        @siblings = obj.siblings
        @height = (@siblings.length+3) * @y_factor * 2

}
</script>

<style scoped>
.planetsection {
  padding-top: 10px;
}
.planetsection svg {
  width: 100%;
}

.primary circle {
  fill: #999;
}
.primary text {
  text-anchor: middle;
  font-size: 14px;
}

.planet {
  stroke: var(--main-view-background);
  stroke-width: 3px;
}
.halo {
  fill: var(--main-view-background);
  stroke: var(--main-view-background);
  stroke-width: 5;
  stroke-linejoin: round;
  vector-effect: non-scaling-stroke;
}
.orbit {
  stroke: #000;
  stroke-width: 0.3px;
  fill: none;
}
.selected {
  stroke-width: 1.5px;
}
</style>
