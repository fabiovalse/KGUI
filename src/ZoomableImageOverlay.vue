<template>
  <g>
    <rect v-for="d in data" :x="d.x" :y="d.y" :width="d.width" :height="d.height"></rect>
  </g>
</template>

<script lang="coffee">
export default {
  props:
    data:
      type: Array
      required: true
}
</script>

<style scoped>
rect {
  fill: rgba(70, 130, 180, 0.5);
  stroke: steelblue;
  stroke-width: 3px;
  vector-effect: non-scaling-stroke;
}
</style>
