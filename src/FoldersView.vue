<template>
  <div class="foldersview">
    <div class="margin"></div>
    <div class="folders">
      <div v-for="folder in folders"
           class="folder_container"
           :style="{width: folder.width !== undefined ? 25*folder.width + '%' : '25%'}">
        <div class="folder" @click="select(folder)" :class="{vfs_img: folder.vfs_img !== undefined}" :style="{height: folder.height !== undefined ? 124*folder.width + 'px' : '124px'}">
          <div v-if="folder.icon !== undefined" class="icon">
            <i :class="'icon-' + folder.icon"></i>
          </div>
          <div v-if="folder.icon == undefined" class="img" :style="{background: 'url('+folder.vfs_img+') #B44646', 'background-position-x': 'center !important', 'background-position-y': 'top !important', 'background-size': '100% !important', 'background-repeat': 'no-repeat !important'}"></div>
          <div class="label">{{folder.label}}</div>
          <button v-if="folder.view !== undefined" class="button" @click="open(folder)">
            <div>
              <i class="icon-open_with"></i>
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
  background: #999;
  padding-top: 60px; /* FIXME this is because of the breadcrumb, but we need a more intelligent way to do this */
  padding-left: 420px; /* 12px more, needed for folders margin */
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
  margin: 35px 12px;
  margin-left: 0;
  background: #B44646;
  box-shadow: 0 2px 4px rgba(0,0,0,0.2), 0 -1px 0px rgba(0,0,0,0.02);
  cursor: pointer;
}

.icon {
  flex-grow: 1;
  width: 100%;
  padding-top: 15px;
  text-align: center;
  font-size: 65px;
  background: #DDD;
  color: #FAFAFA;
}

.img {
  flex-grow: 1;
  width: 100%;
}

.label {
  height: 20px;
  padding: 5px 0px 0px 10px;
  font-size: 13px;
  color: #FAFAFA;
  pointer-events: none;
}

.button {
  position: absolute;
  right: 10px;
  bottom: 10px;
  border: none;
  border-radius: 50%;
  background: #FFF;
  box-shadow: 0 1px 6px 0 rgba(0,0,0,.3);
  transition: box-shadow 150ms cubic-bezier(.4,0,1,1);
  font-size: 20px;
  color: #80131f;
  line-height: 0px;
  padding: 12px;
  cursor: pointer;
}
.button:hover {
  box-shadow: 0 6px 12px rgba(0,0,0,.3);
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
