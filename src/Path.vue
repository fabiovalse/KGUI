<template>
  <g>
    <g>
      <path
        class="path"
        v-if="path !== undefined"
        :d="get_d(path.nodes)"
      />
    </g>
    <g v-for="w in waypoints" :transform="get_transform(w)">
      <circle
        class="waypoint"
        :r="30"
      ></circle>
    </g>
  </g>
</template>

<script lang="coffee">
export default {

  computed:
    path: () -> if @$store.state.selection.directions? then @$store.state.selection.directions.path else undefined
    space: () -> @$store.state.selection.space
    transform: () -> @$store.state.additional.transform
    waypoints: () -> if @$store.state.selection.directions? and @$store.state.selection.directions.path? then @$store.state.selection.directions.path.nodes.filter((n) -> not n.label?).filter (n) => n.space.data.id is @space.id else undefined # FIXME: instead of label a type should be used

  methods:
    get_d: (nodes) ->
      #nodes = nodes.filter (n) => n.space.data.id is @space.id

      if nodes.length > 0
        str = "M#{nodes[0].position[0]} #{nodes[0].position[1]}"

        for i,n of nodes.slice(1)
          str += " L#{n.position[0]} #{n.position[1]}"

        return str
      else
        return ''

    get_transform: (w) -> "translate(#{w.position[0]}, #{w.position[1]}) scale(#{if @transform? then 1/@transform.k else 1})"

}
</script>

<style scoped>
.path {
  fill: none;
  stroke: #00B3FD;
  stroke-width: 7px;
  vector-effect: non-scaling-stroke;
}

.waypoint {
  fill: white;
  stroke: #303030;
  stroke-width: 15px;
}

</style>
