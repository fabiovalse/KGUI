<template>
  <div class="image_section">
    <img v-if="src !== undefined" :src="src"></img>
    <div v-if="src === undefined" class="placeholder"></div>
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
    src: () -> kgl.parse(@config.href, @data)
}
</script>

<style scoped>
.image_section {
  width: 100%;
}

img {
  width: 100%;
  display: block;
}
.placeholder {
  width: 100%;
  height: 240px;
  background: #EEE;
}

</style>
