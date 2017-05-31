<template>
  <g
    v-if="data.position !== undefined"
    class="poi"
    :transform="get_translate()"
    @click="select()"
  >
    <g :transform="get_scale()">
      <circle class="background" r="60" cy="5">
        <title>{{data.label}}</title>
      </circle>
      <circle class="foreground" r="60"></circle>
      <foreignObject x="-50" y="-35" width="100" height="100">
        <i :class="'icon icon-' + data.icon"></i>
      </foreignObject>
      <text class="background label" :class="{hidden: semantic_zoom()}" text-anchor="start" dy="0.35em" x="80">
        {{data.label}}
      </text>
      <text class="foreground label" :class="{hidden: semantic_zoom()}" text-anchor="start" dy="0.35em" x="80">
        {{data.label}}
      </text>
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

  methods:
    select: () -> @$store.dispatch 'select', {id: @data.id}
    get_translate: () -> "translate(#{@data.position[0]}, #{@data.position[1]})"
    get_scale: () -> "scale(#{if @transform? then 1/@transform.k else 1})"
    semantic_zoom: () -> @transform.k < 2.5

}
</script>

<style scoped>
.target text {
  font-weight: bold;
}

.poi {
  cursor: pointer;
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

.poi .icon {
  color: #7b5b5b;
  display: block;
  width: 100px;
  height: 100px;
  font-size: 70px;
  text-align: center;
}

.poi .label {
  font-size: 90px;
}
.poi .background.label {
  fill: white;
  stroke: white;
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
    font-size: 200px;
  }
}

</style>
