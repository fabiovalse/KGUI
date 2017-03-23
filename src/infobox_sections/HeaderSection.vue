<template>
  <div class="header_section" @click="click">
    <div class="title" v-if="config.title !== undefined" v-html="kgl_parse(config.title, data)"></div>
    <div class="subtitle" v-if="config.subtitle !== undefined" v-html="kgl_parse(config.subtitle, data)"></div>
    <div class="hlinks">
      <a v-for="img in config.hlinks" :href="img.url" target="blank">
        <img :src="img.icon" :title="img.label">
      </a>
    </div>
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
  methods:
    click: () -> @$emit 'click'
    kgl_parse: kgl.parse

}
</script>

<style scoped>
.header_section {
  position: relative;
  padding: 30px 25px 20px 25px;
  font-family: sans-serif;
  background: #B44646;
  color: white;
}

.title {
  font-size: 21px;
}
.subtitle {
  margin-top: 6px;
  font-size: 15px;
}

.hlinks {
  position: absolute;
  top: 0;
  right: 0;
}
.hlinks img {
  width: 20px;
  padding: 5px 3px 5px 3px;
}
</style>
