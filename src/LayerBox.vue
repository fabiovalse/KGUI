<template>
  <div class="layerbox">
    <div v-for="l in layers">
      <input type="checkbox" @click="set_layer(l.label)" :checked="l.status"> {{l.label}}
    </div>
  </div>
</template>

<script lang="coffee">
export default {
  computed:
    space: () -> @$store.state.space
    layers: () -> @$store.state.layers
  methods:
    set_layer: (id) -> @$store.commit 'set_layer', id #FIXME: this should be an action dispatch for asynchronously retrieve data
}
</script>

<style scoped>
.layerbox {
  width: 48px;
  background: white;
  border: 1px solid #BBB;
}
.layerbox div {
  cursor: pointer;
}

.mobile_mode .layerbox {
  left: 420px;
}

@media (max-width: 480px) {
  .mobile_mode .layerbox {
    left: 10px;
    bottom: 185px;
  }
}
</style>
