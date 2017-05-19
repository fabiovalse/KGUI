<template>
  <div class="foldersview">
    <div v-if="space.subtitle !== undefined" class="subtitle">{{space.subtitle}}</div>
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
        <div v-if="folder.icon == undefined" class="img"
              :style="{background: 'url('+folder.vfs_img+') #DDD'}"></div>
        
        <div class="title">
          <div class="main">{{folder.label.toUpperCase()}}</div>
          <div class="sub">{{folder.subtitle}}</div>
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
    space: () -> @$store.state.space
    folders: () -> @$store.state.space.subspaces.sort (a,b) -> 
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
  padding: 12px;
  box-sizing: border-box;
  padding-left: calc(var(--left-panel-width) + 12px);
}
.subtitle {
  margin-left: 30px;
  margin-top: 20px;
  margin-bottom: 20px;
  font-size: 20px;
  font-weight: 300;
  color: #333;
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
  height: 55px;
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
  font-size: 16px;
  font-weight: 300;
  color: rgba(0,0,0,0.54);
  margin-top: 4px;
}

.type {
  position: absolute;
  right: 11px;
  bottom: 40px;
  border: none;
  border-radius: 50%;
  background: transparent;
  font-size: 20px;
  color: #858585;
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
