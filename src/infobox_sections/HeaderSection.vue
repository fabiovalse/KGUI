<template>
  <div class="header_section">
    <div class="title" v-if="config.title !== undefined" v-html="kgl_parse(config.title, data)"></div>
    <div class="subtitle" v-if="config.subtitle !== undefined" v-html="kgl_parse(config.subtitle, data)"></div>
    <div class="hlinks">
      <a v-for="img in config.hlinks" :href="kgl_parse(img.url)" target="blank">
        <img :src="kgl_parse(img.icon)" :title="kgl_parse(img.label)">
      </a>
    </div>
    <button v-if="data.view !== undefined" class="button" @click="open(folder)">
      <div>
        <i class="icon-open_with"></i>
      </div>
    </button>
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
    kgl_parse: kgl.parse

}
</script>

<style scoped>
.header_section {
  position: relative;
  height: 68px;
  padding: 16px 24px 20px 24px;
  background: #B44646;
  color: white;
}

.title {
  font-size: 18px;
}
.subtitle {
  margin-top: 11px;
  font-size: 13px;
}

.hlinks {
  position: absolute;
  top: 12px;
  right: 12px;
}
.hlinks img {
  width: 20px;
  padding: 5px 3px 5px 3px;
}

.button {
  position: absolute;
  right: 10px;
  top: -25px;
  border: none;
  border-radius: 50%;
  background: #FFF;
  box-shadow: 0 1px 6px 0 rgba(0,0,0,.3);
  transition: box-shadow 150ms cubic-bezier(.4,0,1,1);
  font-size: 20px;
  color: #80131f;
  line-height: 0px;
  padding: 15px;
  cursor: pointer;
}
.button:hover {
  box-shadow: 0 6px 12px rgba(0,0,0,.3);
}

@media (max-width: 480px) {
  .header_section {
    padding-top: 33px;
    height: 30px;
    order:1;
  }
  .mobile_open .header_section {
    position: fixed;
    width: 100%;
  }
}
</style>
