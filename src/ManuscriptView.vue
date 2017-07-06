<template>
  <div class="manuscriptview">
    <spaceheader></spaceheader>

    <div class="pages">
      <div :class="'page ' + get_grid_template_area(i, pages)" v-for="(page, i) in pages">
        <router-link :to="{name: 'goto_space', params: {space: get_folio_id(i)}}">
          <div class="preview" :style="{'background': get_folio_img(i)}"></div>
          <div :class="'label ' + (get_folio_id(i).slice(-1) == 'r' ? 'recto' : 'verso')">{{get_folio_label(i)}}</div>
        </router-link>
        <div class="line" v-if="get_folio_id(i).slice(-1) == 'r'"></div>
      </div>
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
    get_grid_template_area: (i, pages) ->
      type = @get_folio_id(i).slice(-1)
      if i is 0 and type is 'r'
        return 'rf'
      else if i is pages.length-1 and type is 'v'
        return 'vl'
      else
        return type
  components:
    spaceheader: SpaceHeader
}
</script>

<style scoped>
.manuscriptview {
  height: 100%;
  box-sizing: border-box;
  padding: 12px;
  padding-left: calc(var(--left-panel-width) + 12px);
  overflow-y: scroll;
  --preview-width: 200px;
}

.rf {
  grid-area: rf;
}
.r {
  grid-area: r;
}
.v {
  grid-area: v;
}
.vl {
  grid-area: vl;
}

.pages {
  --grid-vert-gap: 50px;
  width: calc(var(--preview-width) * 2);
  margin: auto;
  margin-top: 60px;
  display: grid;
  grid-gap: var(--grid-vert-gap) 1px;
  grid-template-columns: var(--preview-width) var(--preview-width);
  grid-template-areas: ". rf"
                       "v r"
                       "vl .";
}

.page {
  position: relative;
}
.page .label {
  position: absolute;
  bottom: -2px;
  padding-top: 4px;
  font-size: 18px;
  text-shadow: 1px 0px 0px 4px;
}
.page .label.recto {
  left: calc(var(--preview-width) + 10px);
}
.page .label.verso {
  right: calc(var(--preview-width) + 10px);
}
.page .preview {
  border: 1px solid rgba(0,0,0,0.2);
  box-shadow: 0 4px 8px rgba(0,0,0,0.2), 0 -1px 0px rgba(0,0,0,0.02);
}
.page.v .preview {
  border-top-right-radius: 20px;
  border-bottom-right-radius: 5px;
}
.page.r .preview {
  border-top-left-radius: 20px;
  border-bottom-left-radius: 5px;
}
.page .line {
  position: absolute;
  left: calc(var(--preview-width) * -1.5);
  bottom: calc(var(--grid-vert-gap) / -2);
  width: calc(var(--preview-width) * 3);
  border-top: 1px solid rgba(0,0,0,0.2);
}

.preview {
  width: var(--preview-width);
  height: calc(var(--preview-width) * 1.4);
  margin-right: 20px;
  background-position: center !important;
  background-size: 120% !important;
  background-repeat: no-repeat !important;
}
</style>
