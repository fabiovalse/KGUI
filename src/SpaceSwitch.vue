<template>
  <div class="spaceswitch">
    <div v-if="s.id !== space.id" class="space" :style="get_style(s.thumbnail)" v-for="s in spaces" @click="change_space(s.id)">
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
    get_style: (url) -> "background-image: url(#{url});"
}
</script>

<style scoped>
.spaceswitch {
  display: flex;
  position: absolute;
  bottom: 15px;
  left: 10px;
  z-index: 2;
}
.mobile_mode .spaceswitch {    
  left: 420px;    
}

.space {
  width: 60px;
  height: 60px;
  background: #FFF;
  border-radius: 3px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.2), 0 -1px 0px rgba(0,0,0,0.02);
  cursor: pointer; 
  background-repeat: no-repeat;
  background-size: 60px 60px;
}
.space div {
  line-height: 60px;
  font-size: 12px;
  text-align: center;
  color: #303030;
  font-weight: bold;
  text-shadow: -1px -1px 0 #FFF, 1px -1px 0 #FFF, -1px 1px 0 #FFF, 1px 1px 0 #FFF
}
</style>
