<template>
  <div class="infoview">
    <spaceheader></spaceheader>
    <!-- <div v-if="with_zoomable" class="explore" @click="to_fullscreen"><i class="icon-zoom-in"></i></div> -->
    <div class="details">
      <sections :template_type="'info'"></sections>
    </div>
  </div>
</template>

<script lang="coffee">
import SpaceHeader from './SpaceHeader.vue'
import Sections from './sections/Sections.vue'

export default {
  props: ['config']
  data: () ->
    fullscreen: false
  computed:
    space: () -> @$store.state.selection.space
  components:
    spaceheader: SpaceHeader
    sections: Sections
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
<style>
.infoview .details .sections {
  display: flex;
  flex-direction: column;
  align-items: center;
}
.infoview .details .sections > * {
  width: calc(100% - 20px);
  background: #FFF;
  margin-bottom: 15px;
  border-radius: 2px;
}
.infoview .details .sections > *:first-child {
  margin-top: 40px;
}
</style>