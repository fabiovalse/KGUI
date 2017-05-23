<template>
  <div class="textview">
    <div class="text" v-html="text"></div>
  </div>
</template>

<script lang="coffee">
import kgl from './infobox_sections/kgl.coffee'

export default {
  computed:
    text: () ->
      text = if @$store.state.space? then @$store.state.space.text else ''
      text = text.replace /\n/g, '<br/>'
      text = kgl.parse(text, @$store.state.space)
      return text
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
</style>
