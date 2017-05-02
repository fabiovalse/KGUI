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
  margin: 10px 0px 10px 0px;
  padding: 10px 24px 10px 24px;
}

.title {
  color: rgba(0,0,0,0.54);
  border-bottom: 1px solid #DDD;
  margin-bottom: 10px;
}

.reference {
  margin-bottom: 10px;
}
</style>
