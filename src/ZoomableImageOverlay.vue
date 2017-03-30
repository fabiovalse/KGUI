<template>
  <g>
    <g v-for="obj in data" :class="obj.data.selector" @click="select(obj.id)">
      <rect v-if="obj.data.selector === 'rect'" :x="obj.data.x1" :y="obj.data.y1" :width="obj.data.x2-obj.data.x1" :height="obj.data.y2-obj.data.y1"></rect>
      <circle v-if="obj.data.selector === 'circle'" :cx="obj.data.cx" :cy="obj.data.cy" :r="obj.data.rx-obj.data.cx"></circle>
      <path v-if="obj.data.selector === 'path'" :d="to_path_description(obj.data.points)"></path>
    </g>
  </g>
</template>

<script lang="coffee">
export default {
  props:
    data:
      type: Array
      required: true
    store:
      type: Object
  methods:
    select: (id) -> @store.dispatch 'select', {id: id}
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
  cursor: pointer;
}
</style>
