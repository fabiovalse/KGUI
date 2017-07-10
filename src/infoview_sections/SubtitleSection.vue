<template>
  <div class="subtitlesection" v-html="text"></div>
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
    text: () -> kgl.parse(@config.text, @data)

}
</script>

<style scoped>
.subtitlesection {
  margin-top: 20px;
  font-size: 20px;
  font-weight: 300;
  color: #333;
}
</style>
