<template>
  <div class="spaceswitch">
    <!--<div v-for="s in spaces">
      <input type="radio" name="spaces" :checked="s.id === space.id" @click="change_space(s.id)"> {{s.id}}
    </div>-->
    <div class="space" :class="{selected: s.id === space.id}" :style="get_style(s.thumbnail)" v-for="s in spaces" @click="change_space(s.id)">
      <div>{{s.label}}</div> 
    </div>
  </div>
</template>

<script lang="coffee">
export default {
  computed:
    spaces: () -> @$store.state.spaces
    space: () -> @$store.state.space
  
  methods:
    change_space: (id) -> @$store.dispatch 'change_space', id
    get_style: (url) -> "background-image: url(#{url}); background-size: 40px;"
}
</script>

<style scoped>
.spaceswitch {
  display: flex;
  position: absolute;
  bottom: 20px;
  right: 20px;
  z-index: 2;
}

.space {
  width: 40px;
  height: 40px;
  background: #FFF;
  margin-left: 10px;
  border-radius: 3px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.2), 0 -1px 0px rgba(0,0,0,0.02);
  cursor: pointer; 
  opacity: 0.5;
}
.space:hover {
  opacity: 1;
}
.space div {
  line-height: 60px;
  font-size: 12px;
  text-align: center;
  color: #303030;
  font-weight: bold;
}
.selected {
  opacity: 1;
}
</style>
