<template>
  <div class="text_section" :class="{collapsed: collapsed}">
    <titlesubsection v-if="text !== undefined && config.title !== undefined" :text="config.title"></titlesubsection>
    <span v-if="text !== undefined" v-html="text"></span>
    <morebutton v-if="visible" v-on:expand_collapse="expand_collapse"></morebutton>
  </div>
</template>

<script lang="coffee">
import kgl from './kgl.coffee'
import TitleSubSection from './TitleSubSection.vue'
import MoreButton from './MoreButton.vue'

export default {
  props:
    data:
      type: Object
      required: true
    config:
      type: Object
      required: true
  
  data: () ->
    collapsed: true
    visible: false

  mounted: () ->
    @visible = @$el.clientHeight > 145

  computed:
    text: () -> kgl.parse(@config.text, @data)
    height: () -> if @height? then @height else undefined

  methods:
    expand_collapse: (v) -> @collapsed = v

  components:
    titlesubsection: TitleSubSection
    morebutton: MoreButton
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
  overflow: hidden;
}

.collapsed {
  max-height: 145px;
}
</style>
<style>
.text_section sup {
  vertical-align: top;
  font-size: 0.7em;
}
</style>