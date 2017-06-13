<template>
  <div class="infoview">
    <spaceheader></spaceheader>
    
    <div class="preview">
      <zoomableimageview v-if="space !== undefined && space.innerview === 'zoomableimageview'" :openseadragon_config="config.openseadragon"></zoomableimageview>
      <imageview v-if="space !== undefined && space.innerview === 'imageview'"></imageview>
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
  background: #FFF;
}
.details {
  width: calc(100% - var(--left-panel-width));
}
.preview {
  width: calc(100% - 408px);
  padding: 40px 0px;
  height: 400px;
  border-bottom: 1px solid #e0e0e0;
}

.zoomableimageview {
}
</style>
