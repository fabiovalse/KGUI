<template>
  <g
    v-if="semantic_zoom()"
    class="label"
    :transform="get_translate()"
    @click="select()"
  >
    <text x="1" dy="0.35em">{{data.label}}</text>
  </g>
</template>

<script lang="coffee">
export default {
  props: ['data', 'transform', 'transform_resize']

  methods:
    select: () -> @$store.dispatch 'select', {d: @data}
    get_translate: () -> "translate(#{@data.x}, #{@data.y}) scale(#{if @transform? then 6/(@transform.k*@transform_resize.k) else 1})"
    semantic_zoom: () -> @transform.k > 5
}
</script>

<style scoped>
.label text {
  font-size: 3px;
  font-weight: bold;
  cursor: pointer;
  fill: rgba(0,0,0,0.45);
  text-anchor: middle;
}

</style>
