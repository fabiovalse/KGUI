<template>
  <div v-if="text !== undefined" class="bilingualtext_section">
    <div class="large">{{text[0]}}</div>
    <div>{{text[1]}}</div>
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
.bilingualtext_section {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 24px;
}

.bilingualtext_section > * {
  width: 45%;
}

.large {
  font-size: 30px;
}
</style>
