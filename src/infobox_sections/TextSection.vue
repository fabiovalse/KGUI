<template>
  <div v-if="text !== undefined" class="text_section">
    <titlesubsection v-if="config.title !== undefined" :text="config.title"></titlesubsection>
    <div v-html="text"></div>
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
  padding: 20px 24px 20px 24px;
  font-size: 13px;
  line-height: 19.5px;
  box-sizing: border-box;
}

@media (max-width: 480px) {
  .text_section {
    text-align: left;
  }
  
}
</style>
<style>
.text_section sup {
  vertical-align: top;
  font-size: 0.7em;
}
.infobox .text_section {
  font-size: 13px;
}
.infoview .text_section {
  font-size: 15px;
  font-weight: 300;
}
</style>
