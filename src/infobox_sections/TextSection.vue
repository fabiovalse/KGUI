<template>
  <div class="text_section">
    <span v-if="text !== undefined" v-html="text"></span>
  </div>
</template>

<script lang="coffee">
import kgl from './kgl.coffee'

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

<style scoped>
.text_section {
  padding: 24px;
  font-size: 13px;
  line-height: 19.5px;
  font-family: sans-serif;
  overflow: hidden;
}

</style>
