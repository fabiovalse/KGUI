<template>
  <div class="textview">
    <spaceheader></spaceheader>

    <div class="page" v-for="(page, i) in pages">
      <router-link :to="{name: 'goto_space', params: {space: get_folio_id(i)}}">
        <div class="preview" :style="{'background': get_folio_img(i)}"></div>
        <div class="explore"><i class="icon-zoom_in"></i></div>
        <div class="folio_number">{{get_folio_label(i)}}</div>
      </router-link>
      <div class="text" v-html="page"></div>
    </div>
  </div>
</template>

<script lang="coffee">
import config from './config.coffee'
import kgl from './infobox_sections/kgl.coffee'
import SpaceHeader from './SpaceHeader.vue'

export default {
  computed:
    pages: () ->
      ps = if @$store.state.selection.space? then @$store.state.selection.space.pages else []
      ps = ps.map (d) =>
        d = d.replace /\n/g, '<br/>'
        d = kgl.parse(d, @$store.state.selection.space)
        return d
      return ps
    folii: () -> @$store.state.selection.space.subspaces.sort (a,b) -> a.order - b.order
  methods:
    get_folio_id: (i) -> if @folii[i]? then @folii[i].id else undefined
    get_folio_label: (i) -> if @folii[i]? then @folii[i].label else undefined
    get_folio_img: (i) -> if @folii[i]? then 'url('+config.main_uri+'/images/depictions/'+@folii[i].id+'.jpg) black' else 'black'
  components:
    spaceheader: SpaceHeader
}
</script>

<style scoped>
.textview {
  height: 100%;
  box-sizing: border-box;
  padding: 12px;
  padding-left: calc(var(--left-panel-width) + 12px);
  overflow-y: scroll;
  background: var(--paper-color);
  --preview-height: 400px;
}
.page:not(:last-child) {
  border-bottom: 1px solid #DDD;
  padding-bottom: 16px;
  margin-bottom: 16px;
}
.page {
  display: flex;
  flex-direction: row;
  position: relative;
}
.preview {
  width: 300px;
  height: var(--preview-height);
  margin-right: 20px;
  background-position-x: center !important;
  background-size: contain !important;
  background-repeat: no-repeat !important;
}
.explore {
  --width: 50px;
  position: relative;
  bottom: calc(var(--width) / 2);
  left: calc(100% - var(--width) * 2);
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
.folio_number {
  color: black;
  text-decoration: none; 
  position: absolute;
  top: calc(var(--preview-height) + 2px);
  font-size: 14px;
}
</style>
