<template>
  <div class="image_section" :style="{'background-image': src ? 'url('+src+')' : 'none'}" >
    <div v-if="label !== undefined" class="fake_image ancient_background" :style="{'font-family': font_family}">
      <div class="text">{{label}}</div>
    </div>
    <div v-if="icon !== undefined" class="fake_image">
      <div class="icon"><i :class="'icon-'+icon"></i></div>
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
    icon: () -> kgl.parse(@config.icon, @data, false)
    font_family: () -> @config.font
}
</script>

<style scoped>
.image_section {
  width: 408px;
  height: 214px;
  background-size: cover;
  background-color: #DDD;
}

.fake_image {
  width: 100%;
  height: 100%;
  text-align: center;
}

.text {
  font-size: 200px;
  line-height: 350px;
  color: #40271e;
  text-shadow: 0px 0px 30px rgba(150, 150, 150, 0.9);
  pointer-events: none;
}

.icon {
  font-size: 170px;
  line-height: 400px;
  color: #FFF;
}

.ancient_background {
  background: url(../../data/img/grapheme_background.png);
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
