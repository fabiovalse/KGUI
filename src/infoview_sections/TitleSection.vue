<template>
  <div class="titlesection" v-html="text"></div>
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
.titlesection {
  font-size: 30px;
  font-weight: 300;
  color: black;
}
</style>
