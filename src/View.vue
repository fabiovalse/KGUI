<template>
  <div class="mainview" :class="{mobile_mode: mode !== 'fullmap'}">
    <layerbox v-if="layers !== undefined && layers.length > 0"></layerbox>
    <layer v-for="(l,i) in layers" v-if="l.status"></layer>

    <buildingmapview v-if="space !== undefined && space.view === 'buildingmapview'"></buildingmapview>
    <bilingualtextview v-if="space !== undefined && space.view === 'bilingualtextview'"></bilingualtextview>
  </div>
</template>

<script lang="coffee">
import LayerBox from './LayerBox.vue'
import MapView from './MapView.vue'
import BuildingMapView from './BuildingMapView.vue'
import BilingualTextView from './BilingualTextView.vue'
import TextView from './TextView.vue'
import IframeView from './IframeView.vue'
import Layer from './Layer.vue'

export default {
  props: ['config']
  computed:
    mode: () -> @$store.state.mode
    space: () -> @$store.state.space
    layers: () -> @$store.state.layers
  components:
    buildingmapview: BuildingMapView
    bilingualtextview: BilingualTextView
    layerbox: LayerBox
    layer: Layer
}
</script>

<style scoped>
.buildingmapview {
  width: 100%;
  height: 100%;
  overflow: hidden;
}

.layerbox {
  position: absolute;
  bottom: 85px;
  left: 10px;
}

</style>
