<template>
  <div class="manuscriptview">
    <spaceheader></spaceheader>

    <div class="pages">
      <div :class="'page ' + get_grid_template_area(i, pages)" v-for="(page, i) in pages">
        <svg v-if="get_folio_id(i).slice(-1) == 'r'" class="turn">
          <path class="arrow" d="M 2.4124399,3.5734792 3.8431504,9.7732268 10.024899,8.3425163 6.6055915,6.2009486 C 7.8743344,4.1493633 10.141875,2.7996357 12.724353,2.7996357 c 3.554281,0 6.505684,2.5734804 7.090566,5.965795 L 21.58756,8.4504944 C 20.858708,4.2213487 17.169454,1 12.724353,1 9.5030045,1 6.6685788,2.7006557 5.075901,5.2471416 z" />
          <path class="book" d="m 19,8.6079276 -5,4.5000014 v 11 l 5,-4.5 V 8.6079276 M 6.4999997,11.607929 c -1.95,0 -4.05,0.4 -5.49999995,1.5 v 14.66 c 0,0.25 0.25000005,0.5 0.50000005,0.5 0.1,0 0.15,-0.07 0.25,-0.07 1.3499999,-0.65 3.2999999,-1.09 4.7499999,-1.09 1.95,0 4.0500003,0.4 5.5000003,1.5 1.35,-0.85 3.8,-1.5 5.5,-1.5 1.65,0 3.35,0.31 4.75,1.06 0.1,0.05 0.15,0.03 0.25,0.03 0.25,0 0.5,-0.25 0.5,-0.5 v -14.59 c -0.6,-0.45 -1.25,-0.75 -2,-1 v 2 l 0,5.5 v 6 c -1.1,-0.35 -2.3,-0.5 -3.5,-0.5 -1.7,0 -4.15,0.65 -5.5,1.5 v -7 l 0,-4.5 v -2 c -1.45,-1.1 -3.5500003,-1.5 -5.5000003,-1.5 v 0 z" />
        </svg>
        <router-link :to="{name: 'goto_space', params: {space: get_folio_id(i)}}">
          <div class="preview" :style="{'background': get_folio_img(i)}"></div>
          <div :class="'label ' + (get_folio_id(i).slice(-1) == 'r' ? 'recto' : 'verso')">{{get_folio_label(i)}}</div>
        </router-link>
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
  background: var(--paper-color);
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
  width: calc(var(--preview-width) * 2);
  margin: auto;
  display: grid;
  grid-gap: 40px 1px;
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
  bottom: 5px;
  padding-top: 4px;
  color: #FFF;
  font-size: 18px;
  text-shadow: 1px 0px 0px 4px;
}
.page .label.recto {
  right: 5px;
}
.page .label.verso {
  left: 5px;  
}
.page .preview {
  border: 1px solid #303030;
  box-shadow: 0 2px 4px rgba(0,0,0,0.2), 0 -1px 0px rgba(0,0,0,0.02);
}
.page.v .preview {
  border-top-right-radius: 20px;
  border-bottom-right-radius: 5px;
}
.page.r .preview {
  border-top-left-radius: 20px;
  border-bottom-left-radius: 5px;
}
.page .turn {
  width: 24px;
  height: 29px;
  position: absolute;
  bottom: -34px;
  left: -12px;
}
.page .turn .book {
  fill: #CFCFCF;
}
.page .turn .arrow {
  fill: #9e9c9c;
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
