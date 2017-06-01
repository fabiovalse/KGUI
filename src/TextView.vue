<template>
  <div class="textview">
    <spaceheader></spaceheader>

    <div class="page" v-for="page in pages">
      <div class="text" v-html="page"></div>
    </div>
  </div>
</template>

<script lang="coffee">
import kgl from './infobox_sections/kgl.coffee'
import SpaceHeader from './SpaceHeader.vue'

export default {
  computed:
    pages: () ->
      ps = if @$store.state.selection.space? then @$store.state.selection.space.pages else []
      ps = ps.map (d) =>
        d = d.replace /\n/g, '<br/>'
        d = kgl.parse(d, @$store.state.selection.space)
        return d
      return ps
  components:
    spaceheader: SpaceHeader
}
</script>

<style scoped>
.textview {
  height: 100%;
  box-sizing: border-box;
  padding: 12px;
  padding-left: calc(var(--left-panel-width) + 12px);
  overflow-y: scroll;
  background: var(--paper-color);
}
.page:not(:last-child) {
  border-bottom: 1px solid #DDD;
  padding-bottom: 16px;
  margin-bottom: 16px;
}
</style>
