<template>
  <div class="manuscriptview">
    <spaceheader></spaceheader>

    <div class="faces">
      <div :class="'face ' + get_grid_template_area(i, page_faces)" v-for="(face, i) in page_faces">
        <router-link :to="{name: 'goto_space', params: {space: face.id}}">
          <div class="preview" :style="{'background': get_face_img(face)}"></div>
          <div :class="'label ' + (face.id.slice(-1) == 'r' ? 'recto' : 'verso')">{{face.label}}</div>
        </router-link>
        <div class="line" v-if="face.id.slice(-1) == 'r'"></div>
      </div>
    </div>
  </div>
</template>

<script lang="coffee">
import config from './config.coffee'
import kgl from './sections/kgl.coffee'
import SpaceHeader from './SpaceHeader.vue'

export default {
  computed:
    page_faces: () -> @$store.state.selection.space.subspaces.sort (a,b) -> a.order - b.order
  methods:
    get_face_img: (face) -> 'url('+config.main_uri+'/images/depictions/'+face.id+'.jpg) black'
    get_grid_template_area: (i, page_faces) ->
      type = @page_faces[i].id.slice(-1)
      if i is 0 and type is 'r'
        return 'rf'
      else if i is page_faces.length-1 and type is 'v'
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

.faces {
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

.face {
  position: relative;
}
.face .label {
  position: absolute;
  bottom: -2px;
  padding-top: 4px;
  font-size: 18px;
  text-shadow: 1px 0px 0px 4px;
}
.face .label.recto {
  left: calc(var(--preview-width) + 10px);
}
.face .label.verso {
  right: calc(var(--preview-width) + 10px);
}
.face .preview {
  border: 1px solid rgba(0,0,0,0.2);
  box-shadow: 0 4px 8px rgba(0,0,0,0.2), 0 -1px 0px rgba(0,0,0,0.02);
}
.face.v .preview {
  border-top-right-radius: 20px;
  border-bottom-right-radius: 5px;
}
.face.r .preview {
  border-top-left-radius: 20px;
  border-bottom-left-radius: 5px;
}
.face .line {
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
