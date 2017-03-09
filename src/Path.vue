<template>
  <path
    class="path"
    v-if="path !== undefined"
    :d="get_d(path)"
  />
</template>

<script lang="coffee">
export default {

  computed:
    path: () -> @$store.state.path

  methods:
    get_d: (path) ->
      str = "M#{path[0].position[0]} #{path[0].position[1]}"

      for i,p of path.slice(1)
        str += " L#{p.position[0]} #{p.position[1]}"

      return str

}
</script>

<style scoped>
.path {
  fill: none;
  stroke: #00B3FD;
  stroke-width: 13px;
  stroke-dasharray: 25,20;
}

</style>
