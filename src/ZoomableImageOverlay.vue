<template>
  <g>
    <g v-for="obj in data" :class="obj.selector">
      <rect v-if="obj.selector === 'rect'" :x="obj.x1" :y="obj.y1" :width="obj.x2-obj.x1" :height="obj.y2-obj.y1"></rect>
      <circle v-if="obj.selector === 'circle'" :cx="obj.cx" :cy="obj.cy" :r="obj.rx-obj.cx"></circle>
      <path v-if="obj.selector === 'path'" :d="to_path_description(obj.points)"></path>
    </g>
  </g>
</template>

<script lang="coffee">
export default {
  props:
    data:
      type: Array
      required: true
  methods:
    to_path_description: (points) ->
      points = points.concat([points[0]])
      return (points.map (p,i) -> return if i is 0 then "M#{points[i].x} #{points[i].y}" else "L #{points[i].x} #{points[i].y} ").join('')

}
</script>

<style scoped>
rect, circle, path {
  fill: rgba(70, 130, 180, 0.5);
  stroke: steelblue;
  stroke-width: 3px;
  vector-effect: non-scaling-stroke;
}
</style>
