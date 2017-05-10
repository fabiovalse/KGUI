<template>
  <div class="foldersview">
    <div class="margin"></div>
    <div class="folders">
        
      <div class="folder" v-for="folder in folders"
            @click="open(folder)"
            :class="{vfs_img: folder.vfs_img !== undefined}"
            :style="{
              width: folder.width === 2 ? '384px' : '250px',
              height: folder.height === 2 ? '361px' : '250px'}">

        <div v-if="folder.icon !== undefined" class="icon">
          <i :class="'icon-' + folder.icon"></i>
        </div>
        <div v-if="folder.icon == undefined"
              class="img"
              :style="{
                background: 'url('+folder.vfs_img+') #DDD',
                'background-position-x': 'center !important',
                'background-size': 'cover'}"></div>
        
        <div class="title">
          <div class="main">{{folder.label.toUpperCase()}}</div>
          <div class="sub">{{folder.sub_title}}</div>
        </div>

        <div v-if="folder.view !== undefined" class="type">
          <i :class="folder.view === 'foldersview' ? 'icon-folder' : 'icon-zoom_in'"></i>
        </div>
      </div>

    </div>
  </div>
</template>

<script lang="coffee">
export default {
  computed:
    folders: () ->
      @$store.state.space.subspaces.sort (a,b) -> 
        if not a.width?
          a.width = 1
        if not b.width?
          b.width = 1

        if b.width is a.width
          if b.view?
            return 1
          else
            return -1
        else
          return b.width - a.width
  methods:
    open: (item) -> 
      if item.view?
        @$store.dispatch 'change_space', item.id

      if item.template?
        @$store.dispatch 'select', {id: item.id}
}
</script>

<style scoped>
.foldersview {
  height: 100%;
  overflow-y: scroll;
  background: #f5f5f5;
  padding-top: 60px; /* FIXME this is because of the breadcrumb, but we need a more intelligent way to do this */
  padding-left: 430px; /* 12px more, needed for folders margin */
  box-sizing: border-box;
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

.icon {
  flex-grow: 1;
  width: 100%;
  padding-top: 35px;
  text-align: center;
  font-size: 52px;
  background: #DDD;
  color: #FAFAFA;
}

.img {
  flex-grow: 1;
  width: 100%;
  border-top-right-radius: 2px;
  border-top-left-radius: 2px;
}

.title {
  height: 75px;
  pointer-events: none;
  background: #FFF;
  padding: 24px 48px 24px 16px;
  border-bottom-right-radius: 2px;
  border-bottom-left-radius: 2px;
}
.title .main {
  font-size: 12px;
  font-weight: bold;
  color: #212121;
}
.title .sub {
  font-size: 15px;
  color: rgba(0,0,0,0.54);
  padding-top: 3px;
}

.type {
  position: absolute;
  right: 11px;
  bottom: 45px;
  border: none;
  border-radius: 50%;
  background: transparent;
  font-size: 18px;
  color: #757575;
  line-height: 0px;
  padding: 5px;
  cursor: pointer;
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
