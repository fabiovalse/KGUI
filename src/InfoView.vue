<template>
  <div class="infoview">
    <div class="preview">
      <zoomableimageview v-if="space !== undefined && space.view === 'zoomableimageview'" :config="config.openseadragon"></zoomableimageview>
    </div>
    <div class="details">
      
    </div>
  </div>
</template>

<script lang="coffee">
import ZoomableImageView from './ZoomableImageView.vue'
import IframeView from './IframeView.vue'

export default {
  props: ['config']
  computed:
    space: () -> @$store.state.selection.space
  components:
    zoomableimageview: ZoomableImageView
    iframeview: IframeView
}
</script>

<style scoped>
.infoview {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  overflow: hidden;
  background: #FFF;
}
.details {
  width: 84%;
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
