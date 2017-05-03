<template>
  <div class="foldersview">
    <div class="margin"></div>
    <div class="folders">
      <div v-for="folder in folders"
           class="folder_container"
           :style="{width: folder.width !== undefined ? 25*folder.width + '%' : '25%'}">
        <div class="folder" 
             :class="{vfs_img: folder.vfs_img !== undefined}"
             @click="click(folder)"
             :style="{height: folder.height !== undefined ? 124*folder.width + 'px' : '124px', background: 'url('+folder.vfs_img+') #9c3535'}">
          <div v-if="folder.icon !== undefined" class="icon">
            <i :class="'icon-' + folder.icon"></i>
          </div>
          <div class="label">{{folder.label}}</div>
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
    click: (item) -> 
      if item.view?
        @$store.dispatch 'change_space', item.id
      else
        @$store.dispatch 'select', {id: item.id}
}
</script>

<style scoped>
.foldersview {
  height: 100%;
  overflow-y: scroll;
  background: rgb(230,224,207);
  display: flex;
  padding-top: 60px; /* FIXME this is because of the breadcrumb, but we need a more intelligent way to do this */
  padding-left: 420px; /* 12px more, needed for folders margin */
  box-sizing: border-box;
}
.folders {
  flex-grow: 1;
  height: 100%;
}
.folder_container {
  /*width: 25%;*/
  display: inline-block;
}
.folder {
  position: relative;
  margin: 12px;
  margin-left: 0;
  box-shadow: 0 2px 4px rgba(0,0,0,0.2), 0 -1px 0px rgba(0,0,0,0.02);
  cursor: pointer;
  background-position-x: center !important;
  background-position-y: top !important;
  background-size: 100% !important;
  background-repeat: no-repeat !important;
}

.icon {
  display: table;
  width: 100%;
  height: 100%;
  text-align: center;
  font-size: 65px;
  color: #FAFAFA;
}
.icon i {
  display: table-cell;
  vertical-align: middle;
}

.label {
  position: absolute;
  bottom: 5px;
  left: 10px;
  pointer-events: none;
  font-size: 13px;
  color: #FAFAFA;
  text-shadow: 0px 0px 2px rgba(0, 0, 0, 1);
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
