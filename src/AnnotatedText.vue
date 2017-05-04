<template>
  <div class="annotated_text">
    <span v-if="text !== undefined" v-html="text"></span>
  </div>
</template>

<script lang="coffee">
# FIXME this class is almost identical to text section. refactor classes to clean up this
# FIXME KGL and anchors are not good enough to represent annotations (overlapping)

import kgl from './infobox_sections/kgl.coffee'

export default {
  props:
    data:
      type: Object
      required: true
    config:
      type: Object
      required: true
  computed:
    text: () -> kgl.parse(@config.text, @data)
}
</script>

<style>
/* FIXME WARNING style section with global scope needed  for styling anchors */

.annotated_text a:not(.note) {
  color: inherit;
  padding: 3px;
  border-radius: 3px;
  border: 1px solid rgb(255, 183, 0);
  background-color: rgba(255, 77, 0, 0.08);
}
.annotated_text a:not(.note):hover {
  text-decoration: none;
  background-color: rgba(255, 206, 0, 0.26);
}

.addition {
  color: rgba(0,0,0,0.45);
}
.note:hover {
  text-decoration: none;
  cursor: pointer;
}

</style>
