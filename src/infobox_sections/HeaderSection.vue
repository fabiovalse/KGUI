<template>

  <div class="header_section">
    <div class="title" v-if="config.title !== undefined" v-html="kgl_parse(config.title, data)"></div>
    <div class="subtitle" v-if="config.subtitle !== undefined" v-html="kgl_parse(config.subtitle, data)"></div>
    <div class="hlinks">
      <a v-for="img in config.hlinks" :href="kgl_parse(img.url)" target="blank">
        <img :src="kgl_parse(img.icon)" :title="kgl_parse(img.label)">
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
  top: 12px;
  right: 12px;
}
.hlinks img {
  width: 20px;
  padding: 5px 3px 5px 3px;
}


@media (max-width: 480px){
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

<<<<<<< HEAD
=======
.hlinks {
  position: absolute;
  top: 12px;
  right: 12px;
}
.hlinks img {
  width: 20px;
  padding: 5px 3px 5px 3px;
}
>>>>>>> ff7fb35c24ab3e8b027c1e69b730c08d7e844c7c
=======

>>>>>>> 6713ce2... fixed bugs on expand
</style>
