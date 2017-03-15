<template>
  <g>
    <g>
      <path
        class="path"
        v-if="path !== undefined"
        :d="get_d(path.nodes)"
      />
    </g>
    <g>
      <circle
        class="waypoint"
        v-for="w in waypoints"
        r="20"
        :cx="w.position[0]"
        :cy="w.position[1]"
      ></circle>
    </g>
  </g>
</template>

<script lang="coffee">
export default {

  computed:
    path: () -> @$store.state.path
    space: () -> @$store.state.space
    waypoints: () -> if @$store.state.path? then @$store.state.path.nodes.filter((n) -> not n.label?).filter (n) => n.space.data.id is @space.id else undefined # FIXME: instead of label a type should be used

  methods:
    get_d: (nodes) ->
      nodes = nodes.filter (n) => n.space.data.id is @space.id

      if nodes.length > 0
        str = "M#{nodes[0].position[0]} #{nodes[0].position[1]}"

        for i,n of nodes.slice(1)
          str += " L#{n.position[0]} #{n.position[1]}"

        return str
      else
        return ''

}
</script>

<style scoped>
.path {
  fill: none;
  stroke: #00B3FD;
  stroke-width: 13px;
  stroke-dasharray: 25,20;
}

.waypoint {
  fill: white;
  stroke: #303030;
  stroke-width: 10px;
}

</style>
