<template>
  <div v-if="text !== undefined" class="text_section">
    <titlesubsection v-if="config.title !== undefined" :text="config.title"></titlesubsection>
    <span v-html="text"></span>
  </div>
</template>

<script lang="coffee">
import kgl from './kgl.coffee'
import TitleSubSection from './TitleSubSection.vue'

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
    height: () -> if @height? then @height else undefined

  components:
    titlesubsection: TitleSubSection
}
</script>

<style scoped>
.text_section {
  position: relative;
  padding: 10px 24px 10px 24px;
  font-size: 13px;
  line-height: 19.5px;
  text-align: justify;
  font-family: sans-serif;
}

</style>
<style>
.text_section sup {
  vertical-align: top;
  font-size: 0.7em;
}
</style>