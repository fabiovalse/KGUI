<template>
  <div class="foldersview">
    <div class="margin"></div>
    <div class="folders">
      <div v-for="folder in folders"
           class="folder_container"
           :style="{width: folder.width !== undefined ? 25*folder.width + '%' : '25%', 'max-width': folder.width !== undefined ? folder.width*204+'px' : '204px'}">
        
        <div class="folder"
             @click="select(folder)"
             :class="{vfs_img: folder.vfs_img !== undefined}"
             :style="{height: folder.height !== undefined ? 204*folder.width + 'px' : '204px'}">

          <div v-if="folder.icon !== undefined" class="icon">
            <i :class="'icon-' + folder.icon"></i>
          </div>

          <div v-if="folder.icon == undefined"
               class="img"
               :style="{background: 'url('+folder.vfs_img+') #B44646', 'background-position-x': 'center !important', 'background-size': 'cover'}"></div>
          
          <div class="title">
            <div class="main">{{folder.label.toUpperCase()}}</div>
            <div class="sub">{{folder.sub_title}}</div>
          </div>

          
          <button v-if="folder.view !== undefined" class="button" @click="open(folder)">
            <div>
              <i class="icon-zoom_in"></i>
            </div>
          </button>
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
    select: (item) -> 
      @$store.dispatch 'select', {id: item.id}

    open: (item) ->
      @$store.dispatch 'change_space', item.id
}
</script>

<style scoped>
.foldersview {
  height: 100%;
  overflow-y: scroll;
  background: #b6b6b6;
  padding-top: 60px; /* FIXME this is because of the breadcrumb, but we need a more intelligent way to do this */
  padding-left: 430px; /* 12px more, needed for folders margin */
  box-sizing: border-box;
}
.folders {
  display: flex;
  flex-wrap: wrap;
  align-items: flex-end;
}
.folder {
  display: flex;
  flex-direction: column;
  position: relative;
  margin: 3px 6px 3px 0px;
  margin-left: 0;
  background: #B44646;
  box-shadow: 0 2px 4px rgba(0,0,0,0.2), 0 -1px 0px rgba(0,0,0,0.02);
  cursor: pointer;
  border-radius: 2px;
}

.icon {
  flex-grow: 1;
  width: 100%;
  padding-top: 60px;
  text-align: center;
  font-size: 52px;
  background: #DDD;
  color: #FAFAFA;
}

.img {
  flex-grow: 1;
  width: 100%;
}

.title {
  height: 40px;
  pointer-events: none;
  background: #FFF;
}
.title .main {
  font-size: 12px;
  font-weight: bold;
  padding: 5px 0px 0px 10px;
  color: #212121;
}
.title .sub {
  font-size: 13px;
  padding: 0px 0px 0px 10px;
  color: rgba(0,0,0,0.54);
}

.button {
  position: absolute;
  right: 7px;
  bottom: 45px;
  border: none;
  border-radius: 50%;
  background: transparent;
  font-size: 17px;
  text-shadow: 0px 0px 4px rgba(0,0,0,0.5);
  color: #FFF;
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
