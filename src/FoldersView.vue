<template>
  <div class="foldersview" :class="view">

    <spaceheader></spaceheader>

    <viewctrl :value="view" @input="view = arguments[0]"></viewctrl>
    
    <div class="folders">
      <router-link class="folder_a" v-for="folder in folders" :to="{name: 'goto_space', params: {space: folder.id}}">
        <div class="folder"
          :style="{
            width: folder.width === 2 ? '384px' : '250px',
            height: folder.height === 2 ? '361px' : '250px'}">

          <div v-if="folder.icon !== undefined" class="icon">
            <i :class="'icon-' + folder.icon"></i>
          </div>
          <div v-else class="img"
              :style="{background: 'url('+config.main_uri+'/images/depictions/'+folder.id+'.jpg) #DDD'}"></div>
        
          <div class="title">
            <div class="main" v-html="kgl(folder.label)"></div>
            <div class="sub" v-html="kgl(folder.subtitle)"></div>
          </div>
        </div>
      </router-link>
    </div>
  </div>
</template>

<script lang="coffee">
import kgl from './infobox_sections/kgl.coffee'
import SpaceHeader from './SpaceHeader.vue'
import ViewCtrl from './folders/ViewCtrl.vue'
import config from './config.coffee'

export default {
  data: () ->
    view: 'icons'
  computed:
    folders: () -> @$store.state.selection.space.subspaces.sort (a,b) -> 
      if a.order? and b.order?
        return a.order - b.order
      else
        if not a.width?
          a.width = 1
        if not b.width?
          b.width = 1

        if b.width is a.width
          return b.label < a.label
        else
          return b.width - a.width
    config: () -> config
  methods:
    kgl: (d) -> kgl.parse d, @$store.state.selection.space

  components:
    spaceheader: SpaceHeader
    viewctrl: ViewCtrl
}
</script>

<style scoped>
.foldersview {
  height: 100%;
  overflow-y: scroll;
  padding: 24px;
  box-sizing: border-box;
  padding-left: calc(var(--left-panel-width) + 30px);
}

.folders {
  display: flex;
  flex-wrap: wrap;
  align-items: flex-end;
  margin-left: -8px;
}
.folder {
  display: flex;
  flex-direction: column;
  position: relative;
  margin: 8px;
  background: #DDD;
  box-shadow: 0 2px 4px rgba(0,0,0,0.2), 0 -1px 0px rgba(0,0,0,0.02);
  cursor: pointer;
  border-radius: 2px;
}
.folder_a {
  text-decoration: none;
}

.icon {
  display: flex;
  flex-grow: 1;
  width: 100%;
  justify-content: center;
  align-items: center;
  font-size: 60px;
  background: #DDD;
  color: #FAFAFA;
}

.img {
  flex-grow: 1;
  width: 100%;
  border-top-right-radius: 2px;
  border-top-left-radius: 2px;
  background-position-x: center !important;
  background-size: cover !important;
  background-repeat: no-repeat !important;
}

.title {
  height: 60px;
  pointer-events: none;
  background: #FFF;
  padding: 16px 24px 24px 16px;
  border-bottom-right-radius: 2px;
  border-bottom-left-radius: 2px;
}
.title .main {
  text-transform: uppercase;
  font-size: 12px;
  font-weight: bold;
  color: #212121;
}
.title .sub {
  font-size: 16px;
  font-weight: 300;
  color: rgba(0,0,0,0.54);
  margin-top: 4px;
}

/* list view */
.list .img, .list .icon {
  display: none;
}
.list .folder {
  height: inherit !important;
}

@media (max-width: 480px) {
  .foldersview {
    padding-top: 60px; /* 12px more, needed for folders margin */
    padding-left: 12px;
  }
  .folder_container {
    width: 50%;
  }
  .folders {
    padding-bottom: 320px; /* FIXME hack needed for scrolling */
  }
}
@media (max-width: 800px) {
  .folder_container {
    width: 50%;
  }
}
</style>
<style>
/* FIXME */
.foldersview .title .sub a {
  color: inherit;
}
</style>