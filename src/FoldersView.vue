<template>
  <div class="foldersview">
    <div class="margin"></div>
    <div class="folders">
      <div v-for="folder in folders"
           class="folder_container">
        <div class="folder" @click="open(folder)">
          <div class="icon"><i class="icon-folder"></i></div>
          <div class="label">{{folder.label}}</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="coffee">
export default {
  computed:
    folders: () -> @$store.state.space.subspaces
  methods:
    open: (item) -> @$store.dispatch 'change_space', item.id
}
</script>

<style scoped>
.foldersview {
  height: 100%;
  overflow-y: scroll;
  background: #7b5b5b;
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
  width: 25%;
  display: inline-block;
}
.folder {
  height: 124px;
  margin: 12px;
  margin-left: 0;
  box-shadow: 4px 4px 6px rgba(0,0,0,0.4);
  border-radius: 3px;
  background: rgb(253,233,153);
  position: relative;
  cursor: pointer;
}
.label {
  position: absolute;
  bottom: 12px;
  left: 40px;
  pointer-events: none;
  font-size: 13px;
}
.icon {
  position: absolute;
  bottom: 5px;
  left: 12px;
  font-size: 20px;
  color: rgb(230, 194, 60);
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
