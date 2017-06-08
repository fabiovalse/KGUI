<template>
  <div class="breadcrumb">
    <template v-for="(item,i) in path">
      <router-link class="item" :to="{name: 'goto_space', params: {space: item.id}}">{{item.label}}</router-link>
      <i v-if="i < path.length-1" class="icon-chevron-right" style="color: #888; font-size: 12px;"></i>
    </template>

    <div class="actions"> <!--FIXME: the breadcrumb component should be called Topbar and it should be contains breadcrumb and actions.-->
      <div class="icon"><i :class="'icon-share'"></i></div>
    </div>
  </div>
</template>

<script lang="coffee">
export default {
  props:
    path:
      type: Array
}
</script>

<style scoped>
.breadcrumb {
  background: white;
  position: absolute;
  top: 0;
  left: 0;
  z-index: 6;
  width: 100%;
  height: var(--main-bar-height);
  padding-left: calc(var(--left-panel-width) + 12px);
  box-shadow: 0 2px 4px rgba(0,0,0,0.2), 0 -1px 0px rgba(0,0,0,0.02);
}
.item {
  display: inline-block;
  padding: 10px;
  margin-top: 10px;
  font-family: Roboto, sans-serif;
  font-size: 20px;
  color: #888;
  cursor: pointer;
  text-decoration: none;
}
.item.router-link-active {
  color: #333;
}

.actions {
  position: absolute;
  top: 22px;
  right: calc(var(--left-panel-width) + 12px + 10px);
}
.actions .icon {
  font-size: 20px;
}
</style>
