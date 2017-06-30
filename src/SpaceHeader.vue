<template>
  <header v-if="!hidden" :class="{overlay: overlay}">
    <div v-if="space.label !== undefined" class="label" v-html="kgl(space.label)"></div>
    <div v-if="space.subtitle !== undefined" class="subtitle" v-html="kgl(space.subtitle)"></div>
    <div v-if="space.description !== undefined" class="description" v-html="kgl(space.description)"></div>
  </header>
</template>

<script lang="coffee">
import kgl from './infobox_sections/kgl.coffee'

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
header .label {
  font-size: 30px;
  font-weight: 300;
  color: black;
}
header .subtitle {
  margin-top: 20px;
  font-size: 20px;
  font-weight: 300;
  color: #333;
}
header .description {
  margin-top: 20px;
  font-size: 16px;
  font-weight: 300;
  line-height: 1.2em;
  color: black;
}

/* overlay style */
header.overlay {
  background: rgba(0,0,0,0.6);
}
header.overlay .label,
header.overlay .subtitle,
header.overlay .description {
  color: white;
}
</style>
