<template>
  <g
    v-if="semantic_zoom()"
    class="label"
    :transform="get_translate()"
    @click="select()"
  >
    <text x="2.5" y="2.5">{{data.label}}</text>
  </g>
</template>

<script lang="coffee">
export default {
  props: ['data']

  computed:
    transform: () -> @$store.state.additional.transform

  methods:
    select: () -> @$store.dispatch 'select', {d: @data}
    get_translate: () -> "translate(#{@data.position[0]}, #{@data.position[1]}) scale(#{if @transform? then 6/@transform.k else 1})"
    semantic_zoom: () -> @transform.k > 5
}
</script>

<style scoped>
.label text {
  font-size: 14px;
  font-weight: bold;
  cursor: pointer;
  fill: rgba(0,0,0,0.45);
  text-anchor: middle;
}

</style>
