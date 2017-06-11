<template>
  <g>
    <g v-for="obj in data" :class="get_classes(obj)" @click="select(obj.id)">
      <rect v-if="obj.data.selector === 'rect'" :x="obj.data.x1" :y="obj.data.y1" :width="obj.data.x2-obj.data.x1" :height="obj.data.y2-obj.data.y1"></rect>
      <circle v-if="obj.data.selector === 'circle'" :cx="obj.data.cx" :cy="obj.data.cy" :r="obj.data.rx-obj.data.cx"></circle>
      <path v-if="obj.data.selector === 'path'" :d="to_path_description(obj.data.points)"></path>
      
      <text
        v-if="obj.data.label !== undefined"
        :x="obj.data.cx" :y="obj.data.cy">
          {{obj.data.label}}
      </text>
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
    annotations:
      type: Object

  mounted: () ->
    @$el.style.setProperty '--selected-color', if @annotations.selected_color? then @annotations.selected_color else '#ff9e72'
    @$el.style.setProperty '--color', if @annotations.color? then @annotations.color else '#CCC'

  computed:
    selected: () -> @store.state.selection.target

  methods:
    select: (id) -> 
      @store.commit 'goto_target', id

      if @selected? and @selected.id is id
        @focus id
    focus: (id) ->
      bbox = @$el.querySelector(".obj_#{id.replace('|','_')}").getBBox()
      @viewer.viewport.fitBounds new OpenSeadragon.Rect(bbox.x, bbox.y, bbox.width, bbox.height)
    get_classes: (obj) ->
      classes = {
        selected: @selected? and @selected.id is obj.id
      }
      classes["obj_#{obj.id.replace('|','_')}"] = true
      return classes

    to_path_description: (paths) ->      
      d_attribute = ""

      # Append the first point to the end of the point set for a correct costruction of SVG d attribute
      for path in paths
        path = path.concat([path[0]])
        d_attribute += (path.map (p,i) -> return if i is 0 then "M#{path[i].x} #{path[i].y}" else "L #{path[i].x} #{path[i].y} ").join('')
      
      return d_attribute

}
</script>

<style scoped>
rect, circle, path {
  fill: var(--color);
  vector-effect: non-scaling-stroke;
  cursor: pointer;
}

rect:hover, circle:hover, path:hover {
  stroke: var(--selected-color);
  stroke-width: 3px;
}

.selected rect, .selected circle, .selected path {
  fill: var(--selected-color);
}

text {
  font-size: 0.02px; /* FIXME this should be configurable somehow */
  text-anchor: middle;
}
</style>
