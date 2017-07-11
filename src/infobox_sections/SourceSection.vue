<template>
  <div v-if="sources !== undefined" class="source_section">
    <div class="title">References:</div>
    <div class="reference" v-for="s in sources" v-html="s"></div>
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
    sources: () -> kgl.parse(@config.sources, @data, true)

}
</script>

<style scoped>
.source_section {
  font-size: 12px;
  padding: 20px 24px 10px 24px;
  box-sizing: border-box;
}

.title {
  color: rgba(0,0,0,0.54);
  font-size: 14px;
  margin-bottom: 20px;
}

.reference {
  margin-bottom: 10px;
}
</style>
