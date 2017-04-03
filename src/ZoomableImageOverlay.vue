<template>
  <g>
    <g v-for="obj in data" :class="get_classes(obj)" @click="select(obj.id)">
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
    viewer:
      type: Object

  computed:
    selected: () -> @store.state.target

  methods:
    select: (id) -> 
      @store.dispatch 'select', {id: id}

      if @selected.id is id
        bbox = @$el.querySelector(".obj#{id}").getBBox()
        @viewer.viewport.fitBounds new OpenSeadragon.Rect(bbox.x, bbox.y, bbox.width, bbox.height)
    get_classes: (obj) ->
      classes = {
        selected: @selected? and @selected.id is obj.id
      }
      classes["obj#{obj.id}"] = true
      return classes

    to_path_description: (points) ->
      points = points.concat([points[0]])
      return (points.map (p,i) -> return if i is 0 then "M#{points[i].x} #{points[i].y}" else "L #{points[i].x} #{points[i].y} ").join('')

}
</script>

<style scoped>
rect, circle, path {
  fill: #ffd26d;
  vector-effect: non-scaling-stroke;
  cursor: pointer;
}

rect:hover, circle:hover, path:hover {
  stroke: #ff9e72;
  stroke-width: 3px;
}

.selected rect, .selected circle, .selected path {
  fill: #ff9e72;
}
</style>
