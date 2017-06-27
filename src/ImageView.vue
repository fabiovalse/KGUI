<template>
  <div class="imageview">
    <div v-if="space.icon !== undefined" class="fake_image">
      <div class="icon"><i :class="'icon-'+space.icon"></i></div>
      <div>IMAGE NOT AVAILABLE</div>
    </div>
    <img v-else :src="config.main_uri+'/images/depictions/'+space.id+'.jpg'" />
  </div>
</template>

<script lang="coffee">
import config from './config.coffee'

export default {
  computed:
    space: () -> @$store.state.selection.space
    config: () -> config

}
</script>

<style scoped>
.imageview {
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
}

img {
  max-height: 400px;
}

.fake_image {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 100%;
  font-weight: bold;
  background: #DDD;
  color: #FFF;
}

.icon {
  font-size: 130px;
  color: #FFF;
}
</style>
