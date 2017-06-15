<template>
  <div class="infoview">
    <spaceheader></spaceheader>
    
    <div class="preview">
      <zoomableimageview v-if="space !== undefined && space.innerview === 'zoomableimageview'" :openseadragon_config="config.openseadragon"></zoomableimageview>
      <imageview v-if="space !== undefined && space.innerview === 'imageview'"></imageview>
      <div class="explore"><i class="icon-zoom_in"></i></div>
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
  computed:
    space: () -> @$store.state.selection.space
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
}
.details {
  width: calc(100% - var(--left-panel-width));
}
.preview {
  width: calc(100% - 408px);
  padding: 40px 0px;
  height: 400px;
  border-bottom: 1px solid #e0e0e0;
  position: relative;
}

.explore {
  --width: 50px;
  position: absolute;
  bottom: calc(var(--width) / 2 - 2px);
  right: calc(var(--width) * 1.5);
  width: var(--width);
  height: var(--width);
  color: white;
  background: var(--main-color);
  border-radius: calc(var(--width) / 2);
  text-align: center;
  line-height: 55px;
  font-size: 18px;
  box-shadow: 0 0 4px rgba(0,0,0,.14), 0 4px 8px rgba(0,0,0,.28);
  cursor: pointer;
}
</style>
