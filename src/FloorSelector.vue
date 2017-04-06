<template>
  <div class="floorselector">
    <button v-for="s in spaces" :class="{selected: s.id === space.id, under: s.order > space.order}" @click="change_space(s.id)">{{s.label}}</button>
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
.floorselector {
  cursor: pointer;
  background: white;
  border-radius: 3px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.2), 0 -1px 0px rgba(0,0,0,0.02);  
}

button {
  border: 0;
  display: block;
  background: transparent;
  width: 48px;
  height: 48px;
  cursor: pointer;
  font-size: 16px;
  color: #222;
  fill: #222;
  text-align: center;
  font-weight: bold;
  outline: none;
}

.floorselector button:first-child {
  border-top-left-radius: 3px;
  border-top-right-radius: 3px;
}
.floorselector button:last-child {
  border-bottom-left-radius: 3px;
  border-bottom-right-radius: 3px;
}

.selected {
  background: #B44646;
  color: white;
}
.under {
  background: #EEE;
}


</style>
