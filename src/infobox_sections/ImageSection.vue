<template>
  <div class="image_section">
    <div v-if="src !== undefined" :style="{'background-image': 'url('+src+')'}" class="image"></div>
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

.image {
  width: 408px;
  height: 214px;
  background-size: cover;
}
.placeholder {
  width: 100%;
  height: 240px;
  background: #EEE;
}

</style>
