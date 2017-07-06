<template>
  <div class="dualview">
    <spaceheader></spaceheader>
    
    <div class="space">
      <zoomableimageview></zoomableimageview>
    </div>
    <div class="space textview" v-html="text"></div>
  </div>
</template>

<script lang="coffee">
import SpaceHeader from './SpaceHeader.vue'
import ZoomableImageView from './ZoomableImageView.vue'
import kgl from './infobox_sections/kgl.coffee'

export default {

  computed:
    space: () -> @$store.state.selection.space
    text: () -> 
      t = @$store.state.selection.space.text
      t = t.replace /\n/g, '</p><p>'
      return '<p>' + kgl.parse(t, @$store.state.selection.space) + '</p>'

  components:
    zoomableimageview: ZoomableImageView
    spaceheader: SpaceHeader

}
</script>

<style scoped>
.dualview {
  display: flex;
  flex-direction: row;
  height: 100%;
}

.space {
  width: 50%;
}

.textview {
  padding: 40px 35px;
  overflow-y: scroll;
  line-height: 15px;
  box-sizing: border-box;
}
</style>
