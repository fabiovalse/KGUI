<template>
  <div class="dualview">
    <spaceheader></spaceheader>
    
    <div class="first">
      <sections :template_type="'info'"></sections>
    </div>
    <div class="second textview" v-html="text"></div>

    <router-link v-if="space.next !== undefined" :to="{name: 'goto_space', params: {space: space.next}}">
      <div class="next"><div><i class="icon-chevron-right"></i></div></div>
    </router-link>
    <router-link v-if="space.prev !== undefined" :to="{name: 'goto_space', params: {space: space.prev}}">
      <div class="prev"><div><i class="icon-chevron-left"></i></div></div>
    </router-link>
  </div>
</template>

<script lang="coffee">
import SpaceHeader from './SpaceHeader.vue'
import ZoomableImageView from './sections/zoomable_image/ZoomableImageView.vue'
import Sections from './sections/Sections.vue'
import kgl from './sections/kgl.coffee'

export default {

  computed:
    space: () -> @$store.state.selection.space
    text: () ->
      t = @$store.state.selection.space.text_plaintext
      t = t.replace /\n/g, '</p><p>'
      return '<p>' + kgl.parse(t, @$store.state.selection.space) + '</p>'

  components:
    zoomableimageview: ZoomableImageView
    spaceheader: SpaceHeader
    sections: Sections

}
</script>

<style scoped>
.dualview {
  display: flex;
  flex-direction: row;
  height: 100%;
}

.first > * {
  position: relative !important;
  width: 100%;
  height: 100%;
}

.first {
  width: 65%;
}
.second {
  width: 35%;
}

.textview {
  padding: 40px 35px;
  overflow-y: scroll;
  line-height: 15px;
  box-sizing: border-box;
}

.next, .prev {
  --size: 100px;
  position: absolute;
  top: calc(50% - var(--size));
  width: var(--size);
  height: var(--size);
  background: rgba(255,255,255,0.4);
  z-index: 4;
  border-radius: calc(var(--size) / 2);
  box-shadow: 0 4px 8px rgba(0,0,0,0.2), 0 -1px 0px rgba(0,0,0,0.02);
}
.next div {
  margin-top: 40px;
  margin-left: 20px;
}
.prev div {
  margin-top: 40px;
  margin-left: 60px;
}
.next {
  right: calc(var(--size) / -2);
}
.prev {
  left: calc(var(--size) / -2);
}
</style>
