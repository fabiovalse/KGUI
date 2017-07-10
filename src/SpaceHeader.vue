<template>
  <header v-if="!hidden" :class="{overlay: overlay}">
    <sections :template_type="'header'"></sections>
  </header>
</template>

<script lang="coffee">
import kgl from './infobox_sections/kgl.coffee'
import Sections from './infoview_sections/Sections.vue'

export default {
  props:
    overlay:
      type: Boolean
      'default': false
  computed:
    space: () -> @$store.state.selection.space
    hidden: () -> @space.hide_header # FIXME this should use cascading
  methods:
    kgl: (d) -> kgl.parse d, @space
  components:
    sections: Sections

}
</script>

<style scoped>
header {
  --margin: 16px;
  position: absolute;
  top: 0;
  left: 0;
  width: calc(var(--left-panel-width) - 2 * var(--margin));
  z-index: 3;
  margin: var(--margin);
  padding: var(--margin);
  box-sizing: border-box;
}
</style>
<style>
/* overlay style */
header.overlay {
  background: rgba(0,0,0,0.6);
}
header.overlay .titlesection,
header.overlay .subtitlesection,
header.overlay .descriptionsection {
  color: white;
}
</style>
