<template>
  <div class="header_section">
    <div class="title" v-if="config.title !== undefined" v-html="kgl_parse(config.title, data)"></div>
    <div class="subtitle" v-if="config.subtitle !== undefined" v-html="kgl_parse(config.subtitle, data)"></div>
    <div class="hlinks">
      <a v-for="img in config.hlinks" :href="kgl_parse(img.url)" target="blank">
        <img :src="kgl_parse(img.icon)" :title="kgl_parse(img.label)">
      </a>
    </div>
    <div v-if="config.id !== undefined" class="explore"><a :href="get_link(kgl_parse(config.id, data))"><i class="icon-zoom_in"></i></a></div>
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
  computed:
    local_path: () -> @$store.state.selection.local_path
  methods:
    kgl_parse: kgl.parse
    get_link: (id) -> "#/#{id}"

}
</script>

<style scoped>
.header_section {
  position: relative;
  height: 68px;
  padding: 16px 24px 20px 24px;
  background: var(--main-color);
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
  right: 0px;
  top: -50px;
  border: none;
  background: transparent;
  font-size: 22px;
  color: #FFF;
  line-height: 0px;
  padding: 15px;
  cursor: pointer;
}

.explore {
  --width: 50px;
  position: absolute;
  top: calc(var(--width) / 2 * -1);
  right: 15px;
  width: var(--width);
  height: var(--width);
  background: #BBB;
  border-radius: calc(var(--width) / 2);
  text-align: center;
  line-height: 55px;
  font-size: 18px;
  box-shadow: 0 0 4px rgba(0,0,0,.14), 0 4px 8px rgba(0,0,0,.28);
  cursor: pointer;
}
.explore a {
  color: #FFF;
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
