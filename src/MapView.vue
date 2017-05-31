<template>
  <div class="mapview" @click="clicked_nowhere">
    <svg>
      <floors></floors>
      <path v-if="path !== undefined"
        class="path"
        :d="get_d(path)"/>
      <g v-for="(poi, i) in pois"
        v-if="poi.position !== undefined"
        class="poi"
        :class="{target: target !== undefined && poi.id == target.id, from: from !== undefined && poi.id == from.id, to: to !== undefined && poi.id == to.id}"
        :transform="'translate('+poi.position[0]+' '+poi.position[1]+')'"
        @click.stop="select(i)"
      >
        <circle r="5"/>
        <text x="8" dy=".35em">{{poi.label}}</text>
        <rect x="-15" y="-15" class="mobile_click"></rect>
      </g>
    </svg>
  </div>
</template>

<script lang="coffee">
export default {

  computed:
    pois: () -> if @$store.state.additional.nodes? then @$store.state.additional.nodes else []
    target: () -> @$store.state.selection.target
    from: () -> @$store.state.selection.from
    to: () -> @$store.state.selection.to
    path: () -> @$store.state.selection.path

  methods:
    clicked_nowhere: () ->
    select: (i) -> @$store.dispatch 'select', {id: @pois[i].id}
    get_d: (path) -> 
      str = "M#{path[0].position[0]} #{path[0].position[1]}"

      for i,p of path.slice(1)
        str += " L#{p.position[0]} #{p.position[1]}"

      return str

}
</script>

<style scoped>
svg {
  width: 100%;
  height: 100%;
}
.poi {
  cursor: pointer;
}
.path {
  fill: none;
  stroke: black;
}
.poi text {
  font-family: sans-serif;
}
.target.poi text {
  font-weight: bold;
}
.from.poi circle {
  fill: blue;
}
.to.poi circle {
  fill: green;
}

@media (max-width: 480px) {
  .mobile_click {
    width: 100px;
    height: 30px;
    fill: transparent;
  }
}
</style>
