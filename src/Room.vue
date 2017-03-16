<template>
  <g
    v-if="semantic_zoom()"
    class="room"
    :transform="get_translate()"
    @click="select()"
  >
    <text>{{data.label}}</text>
  </g>
</template>

<script lang="coffee">
export default {
  props: ['data']

  computed:
    transform: () -> @$store.state.transform

  methods:
    select: () -> @$store.dispatch 'select', {id: @data.id}
    get_translate: () -> "translate(#{@data.position[0]}, #{@data.position[1]})"
    semantic_zoom: () -> @transform.k > 3
}
</script>

<style scoped>
.room text {
  font-size: 14px;
  font-weight: bold;
  cursor: pointer;
  fill: rgba(0,0,0,0.45);
  text-anchor: middle;
}

</style>
