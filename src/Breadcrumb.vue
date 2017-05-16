<template>
  <div class="breadcrumb">
    <template v-for="(item,i) in path">
      <a class="item" @click="open(item)">{{item.label}}</a>
      <i v-if="i < path.length-1" class="icon-chevron-right" style="color: black; font-size: 12px;"></i>
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
}
.item {
  display: inline-block;
  padding: 10px;
  margin-top: 10px;
  font-size: 18px;
  color: #333;
  cursor: pointer;
  text-decoration: none;
}
.breadcrumb > * {
  opacity: 0.5;
}
.item:last-child {
  opacity: 1;
}
</style>
