<template>
  <div class="image_section">
    <div class="image" :class="{circled: config.circled}" :style="{'background-image': src ? 'url('+src+')' : 'none'}" ></div>
    
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
  height: 214px;
  background-size: cover;
  background-color: #CCC;
  display: flex;
  align-items: center;
  justify-content: center;
}

.image {
  width: 100%;
  height: 100%;
  background-size: var(--left-panel-width);
}
.circled {
  width: 150px;
  height: 150px;
  border-radius: 50%;
  background-repeat: no-repeat;
  background-position: 50% 20%;
  background-size: unset;
}

.fake_image {
  width: 100%;
  height: 100%;
  text-align: center;
}

.text {
  font-size: 150px;
  line-height: 270px;
  color: #40271e;
  text-shadow: 0px 0px 30px rgba(150, 150, 150, 0.9);
  pointer-events: none;
}

.icon {
  font-size: 150px;
  line-height: 270px;
  color: #FFF;
}

.ancient_background {
  background: url(../../img/grapheme_background.png);
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
