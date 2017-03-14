<template>
  <div class="mainview" :class="{mobile_mode: mode !== 'fullmap'}">
    <layerbox v-if="layers !== undefined && layers.length > 0"></layerbox>
    <layer v-for="(l,i) in layers" v-if="l.status"></layer>

    <buildingmapview v-if="space === 'T' || space === '1' || space === '2' || space === '3'"></buildingmapview>
    <textview v-if="space === 'text'"></textview>
    <iframeview v-if="space === 'iframe'"></iframeview>
  </div>
</template>

<script lang="coffee">
import LayerBox from './LayerBox.vue'
import MapView from './MapView.vue'
import BuildingMapView from './BuildingMapView.vue'
import TextView from './TextView.vue'
import IframeView from './IframeView.vue'
import Layer from './Layer.vue'

export default {
  props: ['config']
  computed:
    mode: () -> @$store.state.mode
    space: () -> if @$store.state.space? then @$store.state.space.label else undefined
    layers: () -> @$store.state.layers
  components:
    buildingmapview: BuildingMapView
    textview: TextView
    layerbox: LayerBox
    layer: Layer
    iframeview: IframeView
}
</script>

<style scoped>
.buildingmapview {
  width: 100%;
  height: 100%;
  overflow: hidden;
}
.textview {
  height: 100%;
  background: #F0E0C8;
  overflow-y: scroll;
  overflow-x: hidden;
}

.layerbox {
  position: absolute;
  bottom: 85px;
  left: 10px;
}

</style>
