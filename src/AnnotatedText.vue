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

.annotated_text a {
  color: inherit;
  padding: 3px;
  border-radius: 3px;
  border: 1px solid rgb(255, 199, 0);
  background-color: rgba(255, 255, 0, 0.08);
}
.annotated_text a:hover {
  text-decoration: none;
  background-color: rgba(255, 255, 0, 0.4);
}

</style>
