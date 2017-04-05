<template>
  <div class="spaceswitch">
    <div v-for="s in spaces">
      <input type="radio" name="spaces" :checked="s.id === space.id" @click="change_space(s.id)"> {{s.id}}
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
}
</script>

<style scoped>
.spaceswitch {
  cursor: pointer;
  width: 300px;
  height: 80px;
  background: white;
  border: 1px solid #BBB;

  position: absolute;
  bottom: 5px;
  right: 5px;
  z-index: 2;
}
</style>
