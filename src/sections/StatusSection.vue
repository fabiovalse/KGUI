<template>
  <div 
    class="status_section" 
    :class="{full: nodes[data._key].presence, empty: !nodes[data._key].presence}"
    v-if="nodes != undefined && presence != undefined"
  >
    <i v-if="!presence" class="icon icon-alert"></i>
    <div v-if="!presence" class="message">
      Al momento la stanza {{destination ? 'di destinazione ' : ''}}potrebbe essere vuota
    </div>
  </div>
</template>

<script lang="coffee">
import kgl from './kgl.coffee'

export default {
  props:
    data:
      type: Object
      required: true
    destination:
      default: false
  computed:
    nodes: () -> if @$store.state.selection.space? then @$store.state.selection.space.node_index else undefined
    presence: () -> @nodes[@data._key].presence

}
</script>

<style scoped>
.status_section {
  position: relative;
  padding: 16px;
  font-size: 14px;
  display: flex;
  align-items: center;
}
.icon {
  color: #ffaa45;
  padding-top: 2px;
  font-size: 22px;
  margin-right: 10px;
}
.message {
  color: #555;
}
.empty {
  background: #fff4d5;
}
</style>
