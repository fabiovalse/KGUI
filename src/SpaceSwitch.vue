<template>
  <div class="spaceswitch">
    <div v-for="s in spaces">
      <input type="radio" name="spaces" :checked="s.current" @click="change_space(s.label)"> {{s.label}}
    </div>
  </div>
</template>

<script lang="coffee">
export default {
  computed:
    spaces: () -> @$store.state.spaces
  
  methods:
    change_space: (id) -> @$store.dispatch 'change_space', id
}
</script>

<style scoped>
.spaceswitch {
  cursor: pointer;
  width: 75px;
  height: 80px;
  background: white;
  border: 1px solid #BBB;
}
.mobile_mode .spaceswitch {
  left: 420px;
}

@media (max-width: 480px) {
  .mobile_mode .spaceswitch {
    left: 10px;
    bottom: 110px;
  }
}
</style>
