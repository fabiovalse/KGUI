<template>
  <div 
    class="status_section" 
    :class="{full: nodes[data._key].presence, empty: !nodes[data._key].presence}"
    v-if="nodes != undefined && presence != undefined"
  >
    <div>
      <i v-if="!presence" class="icon-alert"></i>
      {{presence ? 'Presenza segnalata in stanza' : 'Stanza al momento vuota'}}
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
    config:
      type: Object
      required: true
  computed:
    nodes: () -> if @$store.state.selection.space? then @$store.state.selection.space.node_index else undefined
    presence: () -> @nodes[@data._key].presence

}
</script>

<style scoped>
.status_section {
  position: relative;
  padding: 5px 16px;
  font-size: 14px;
}

.full, .empty {
  color: #FFF;
  font-size: 12px;
}
.full {
  background: #378a24;
}
.empty {
  background: #c18f00;
}
</style>
