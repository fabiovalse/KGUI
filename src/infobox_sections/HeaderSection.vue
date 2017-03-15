<template>
  <div class="header_section">
    <div class="title" v-if="config.title !== undefined" v-html="kgl_parse(config.title, data)"></div>
    <div class="subtitle" v-if="config.subtitle !== undefined" v-html="kgl_parse(config.subtitle, data)"></div>
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
  methods:
    kgl_parse: kgl.parse
}
</script>

<style scoped>
.header_section {
  padding: 24px;
  font-family: sans-serif;
  background: #B44646;
  color: white;
}

.title {
  font-size: 21px;
}
.subtitle {
  margin-top: 6px;
  font-size: 15px;
}

</style>
