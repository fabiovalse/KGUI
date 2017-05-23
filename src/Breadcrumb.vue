<template>
  <div class="breadcrumb">
    <template v-for="(item,i) in path">
      <a class="item" @click="open(item)">{{item.label}}</a>
      <i v-if="i < path.length-1" class="icon-chevron-right" style="color: #888; font-size: 12px;"></i>
    </template>
  </div>
</template>

<script lang="coffee">
export default {
  props:
    path:
      type: Array
  methods:
    open: (item) -> @$store.dispatch 'change_space', item.id
}
</script>

<style scoped>
.breadcrumb {
  background: white;
  position: absolute;
  top: 0;
  left: 0;
  z-index: 5;
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
.item:last-child {
  color: #333;
}
</style>
