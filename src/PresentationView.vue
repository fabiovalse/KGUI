<template>
  <div class="presentationview">
    <spaceheader></spaceheader>

    <div class="subspaces">
      <div v-for="s in sorted_subspaces" class="subspace">
        <div class="label">{{s.label}}</div>
        
        <div class="folders">
          <router-link class="folder_a" v-for="folder in s.subspaces" :to="{name: 'goto_space', params: {space: folder.id}}">
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
    </div>
  </div>
</template>

<script lang="coffee">
import kgl from './infobox_sections/kgl.coffee'
import SpaceHeader from './SpaceHeader.vue'
import db from './database.coffee'
import config from './config.coffee'
import Vue from 'vue'

export default {
  data: () ->
    subspaces: []

  mounted: () ->
    @space.subspaces.forEach (s) =>
      db.query_space s.id, (space) => @subspaces.push space

  computed:
    config: () -> config
    space: () -> @$store.state.selection.space
    sorted_subspaces: () -> @subspaces.sort (a,b) -> a.order - b.order 

  methods:
    kgl: (d) -> kgl.parse d, @space

  components:
    spaceheader: SpaceHeader

}
</script>

<style scoped>
.presentationview {
  height: 100%;
  overflow-y: scroll;
  padding-top: 32px; /* FIXME this is because of the breadcrumb, but we need a more intelligent way to do this */
  margin-left: calc(var(--left-panel-width));
  padding-left: 30px;
  padding-right: 30px;
  box-sizing: border-box;
  background: #FDFDFD;
}

.subspace {
  margin-bottom: 50px;
}
.subspace .label {
  color: rgba(0,0,0,0.87);
  font-size: 21px;
  padding: 10px 0px 24px 12px;
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

</style>
<style>
/* FIXME */
.presentationview .title .sub a {
  color: inherit;
}
</style>
