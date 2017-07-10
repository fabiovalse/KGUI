<template>
  <div class="imagesection">
    <img :src="url" />
  </div>
</template>

<script lang="coffee">
import kgl from '../infobox_sections/kgl.coffee'

export default {
  props:
    data:
      type: Object
      required: true
    config:
      type: Object
      required: true

  computed:
    url: () -> kgl.parse(@config.href, @data, false)

}
</script>

<style scoped>
.imagesection {
  margin-top: 20px;
}
.imagesection img {
  width: 100%;
  border-radius: 2px;
}
</style>
