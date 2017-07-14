<template>
  <div v-if="space !== undefined" class="mainview" :class="{mobile_mode: mode !== undefined}">
    <infoview v-if="space.template !== undefined && space.view === 'infoview'" :config="config"></infoview>
    <buildingmapview v-if="space.view === 'buildingmapview'"></buildingmapview>
    <textview v-if="space.view === 'textview'"></textview>
    <dualview v-if="space.view === 'dualview'"></dualview>
    <manuscriptview v-if="space.view === 'manuscriptview'"></manuscriptview>
    <bilingualtextview v-if="space.template !== undefined && space.view === 'bilingualtextview'"></bilingualtextview>
    <zoomableimageview v-if="space.view === 'zoomableimageview'" :config="config.openseadragon"></zoomableimageview>
    <foldersview v-if="space.view === 'foldersview'"></foldersview>
    <iframeview v-if="space.view === 'iframeview'" :url="space.url"></iframeview>
    <radicalview v-if="space.view === 'radicalview'"></radicalview>
    <presentationview v-if="space.view === 'presentationview'"></presentationview>
  </div>
</template>

<script lang="coffee">
import MapView from './MapView.vue'
import BuildingMapView from './BuildingMapView.vue'
import TextView from './TextView.vue'
import ManuscriptView from './ManuscriptView.vue'
import BilingualTextView from './BilingualTextView.vue'
import FoldersView from './FoldersView.vue'
import ZoomableImageView from './sections/zoomable_image/ZoomableImageView.vue'
import IframeView from './IframeView.vue'
import RadicalView from './RadicalView.vue'
import PresentationView from './PresentationView.vue'
import InfoView from './InfoView.vue'
import DualView from './DualView.vue'

export default {
  props: ['config']
  computed:
    mode: () -> @$store.state.selection.mode
    space: () -> @$store.state.selection.space
  components:
    buildingmapview: BuildingMapView
    textview: TextView
    manuscriptview: ManuscriptView
    bilingualtextview: BilingualTextView
    foldersview: FoldersView
    zoomableimageview: ZoomableImageView
    iframeview: IframeView
    radicalview: RadicalView
    presentationview: PresentationView
    infoview: InfoView
    dualview: DualView
}
</script>

<style scoped>
.buildingmapview {
  width: 100%;
  height: 100%;
  overflow: hidden;
}
</style>
