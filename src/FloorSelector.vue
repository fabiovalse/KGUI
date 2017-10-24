<template>
  <div class="floorselector">
    <button 
      v-for="(floor, floor_index) in floors" 
      :class="{selected: floor_index === current_floor, under: floor_index > current_floor}"
      @click="change_floor(floor_index)"
    >{{floor.label}}</button>
  </div>
</template>

<script lang="coffee">
export default {
  props: ['current_floor']

  computed:
    floors: () -> @$store.state.selection.space.floors
  
  methods:
    change_floor: (floor_index) -> @$emit 'select', floor_index
}
</script>

<style scoped>
.floorselector {
  display: flex;
  flex-direction: column-reverse;
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


@media (max-width: 480px) {
  .floorselector {
    bottom: 90px;
  }
}

</style>
