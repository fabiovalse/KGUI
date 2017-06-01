<template>
  <div class="infoview">
    <spaceheader></spaceheader>
    
    <div class="preview">
      <zoomableimageview v-if="space !== undefined && space.view === 'zoomableimageview'" :config="config.openseadragon"></zoomableimageview>
    </div>
    <div class="details">
      
    </div>
  </div>
</template>

<script lang="coffee">
import SpaceHeader from './SpaceHeader.vue'
import ZoomableImageView from './ZoomableImageView.vue'
import IframeView from './IframeView.vue'

export default {
  props: ['config']
  computed:
    space: () -> @$store.state.selection.space
  components:
    zoomableimageview: ZoomableImageView
    iframeview: IframeView
    spaceheader: SpaceHeader
}
</script>

<style scoped>
.infoview {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  overflow: hidden;
  background: #FFF;
}
.preview, .details {
  width: 84%;
}
.preview {
  padding: 40px 20px;
  height: 400px;
  border-bottom: 1px solid #e0e0e0;
}

.zoomableimageview {
}
</style>
