<template>
  <div class="image_section" :style="{'background-image': 'url('+src+')'}" >
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
  width: 408px;
  height: 214px;
  background-size: cover;
  background-color: #EEE;
}

</style>
