<template>
  <div class="text_section">
    <titlesubsection v-if="text !== undefined && config.title !== undefined" :text="config.title"></titlesubsection>
    <span v-if="text !== undefined" v-html="text"></span>
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

  components:
    titlesubsection: TitleSubSection
}
</script>

<style scoped>
.text_section {
  padding: 10px 24px 10px 24px;
  font-size: 13px;
  line-height: 19.5px;
  text-align: justify;
  font-family: sans-serif;
  overflow: hidden;
}

sup {
  vertical-align: top;
  font-size: 0.7em;
}

</style>
