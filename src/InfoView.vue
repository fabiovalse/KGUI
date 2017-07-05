<template>
  <div class="infoview">
    <spaceheader></spaceheader>
    
    <div class="preview">
      <zoomableimageview v-if="with_zoomable"
        :fullscreen="fullscreen"
        :closeable="true"
        @click.native="to_fullscreen"
        @close="fullscreen = false">
      </zoomableimageview>
      <imageview v-if="with_image"></imageview>
      <div v-if="with_zoomable" class="explore" @click="to_fullscreen"><i class="icon-zoom-in"></i></div>
    </div>
    <div class="details">
      <sections></sections>
    </div>
  </div>
</template>

<script lang="coffee">
import SpaceHeader from './SpaceHeader.vue'
import ZoomableImageView from './ZoomableImageView.vue'
import ImageView from './ImageView.vue'
import IframeView from './IframeView.vue'
import Sections from './infoview_sections/Sections.vue'

export default {
  props: ['config']
  data: () ->
    fullscreen: false
  computed:
    space: () -> @$store.state.selection.space
    with_zoomable: () -> @space? and @space.innerview is 'zoomableimageview'
    with_image: () -> @space? and @space.innerview is 'imageview'
  methods:
    to_fullscreen: () -> @fullscreen = true
  components:
    zoomableimageview: ZoomableImageView
    iframeview: IframeView
    spaceheader: SpaceHeader
    sections: Sections
    imageview: ImageView
}
</script>

<style scoped>
.infoview {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  overflow: scroll;
  overflow-x: hidden;
  --preview-height: 400px;
  --preview-margin: 40px;
}
.details {
  width: calc(100% - var(--left-panel-width));
}
.preview {
  width: calc(100% - var(--left-panel-width));
  padding: var(--preview-margin) 0px;
  height: var(--preview-height);
  border-bottom: 1px solid #e0e0e0;
}

.explore {
  --width: 50px;
  position: relative;
  bottom: calc(var(--width) / 2);
  left: calc(100% - var(--width) * 2.5);
  width: var(--width);
  height: var(--width);
  color: white;
  background: var(--main-color);
  border-radius: calc(var(--width) / 2);
  box-shadow: 0 0 4px rgba(0,0,0,.14), 0 4px 8px rgba(0,0,0,.28);
  cursor: pointer;
}
.explore i {
  display: block;
  padding-top: 16px;
  text-align: center;
  font-size: 18px;
}
</style>
