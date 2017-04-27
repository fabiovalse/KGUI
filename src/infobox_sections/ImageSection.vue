<template>
  <div class="image_section" :style="{'background-image': src ? 'url('+src+')' : 'none'}" >
    <div v-if="label !== undefined" class="fake_image" :style="{'font-family': font_family}">
      <div class="text">{{label}}</div>
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
  computed:
    src: () -> kgl.parse(@config.href, @data, false)
    label: () -> kgl.parse(@config.label, @data, false)
    font_family: () -> @config.font
}
</script>

<style scoped>
.image_section {
  width: 408px;
  height: 214px;
  background-size: cover;
  background-color: #EEE;
}

.fake_image {
  width: 100%;
  height: 100%;
  text-align: center;
  font-size: 200px;
  background: url(../../data/img/grapheme_background.png);
}
.text {
  line-height: 350px;
  color: #353535;
  text-shadow: 0px 0px 30px rgba(150, 150, 150, 0.9);
  pointer-events: none;
}

@media (max-width: 480px){
  .image_section {
    overflow: hidden;
    order: 2;
  }
  .mobile_open .image_section {
    margin-top: 80px;
  }
}

</style>
