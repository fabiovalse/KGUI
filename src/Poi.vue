<template>
  <g 
  :class="{target: target !== undefined && target.id == data.id}"
  :transform="get_transform()"
  @click="select()"
  >
    <circle r="8"/>
    <text x="10" y="0" dy="0.35em">{{data.label}}</text>
  </g>
</template>

<script lang="coffee">
export default {
  props: ['data']

  computed:
    target: () -> @$store.state.target
    transform: () -> @$store.state.transform

  methods:
    select: () -> @$store.dispatch 'select', {id: @data.id}
    get_transform: () -> "translate(#{@data.position[0]}, #{@data.position[1]}) scale(#{if @transform? then 6/@transform.k else 1})"

}
</script>

<style scoped>
.target text {
  font-weight: bold;
}
</style>
