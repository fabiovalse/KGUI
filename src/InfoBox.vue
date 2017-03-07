<template>
  <div class="infobox" :class="{mobile_open: mobile_open}" @click="click">
    <div v-if="target !== undefined" class="target_info">
      <div class="expand"><span v-if="mobile_open">v</span><span v-else>^</span></div>
      <div style="background: #b44646; height: 100px">
        <div><b>{{target.label}}</b></div>
        <button v-if="searchdirectionsbox_enabled && target.position !== undefined" @click.stop="click_directions">D</button>
        <div>{{target.description}}</div>
      </div>
      <div v-if="target.out.length > 0">
        <div><b>Related nodes</b></div>
        <ul>
          <li
            v-for="d in target.out"
            class="node"
            @click.stop="click_node(d)"
          >{{d.label}}</li>
        </ul>
      </div>
    </div>
    <div v-if="mode === 'directions'" class="directions_info">
      <div class="expand"><span v-if="mobile_open">v</span><span v-else>^</span></div>
      Direzionati!
    </div>
  </div>
</template>

<script lang="coffee">
export default {
  props:
    searchdirectionsbox_enabled:
      type: Boolean
    mobile_open:
      type: Boolean
  computed:
    mode: () -> @$store.state.mode
    target: () -> @$store.state.target
  methods:
    click_directions: () -> @$store.dispatch 'request_directions', {def: true}
    click_node: (d) -> @$store.dispatch 'select', {id: d.id}
    click: () -> @$emit 'mobile_open'
}
</script>

<style scoped>
.infobox {
  box-shadow: 0 0 20px rgba(0,0,0,0.3);
  padding-top: 130px;
}
.node {
  cursor: pointer;
}
.mobile_open {
  top: 0%;
  margin-top: 0px;
}
button {
  float: right;
  margin-right: 20px;
  width: 60px;
  height: 60px;
  font-size: 20px;
}

.target_info, .directions_info {
  display: flex;
  flex-direction: column;
}
.expand {
  display: none;
  text-align: center;
}

@media (max-width: 480px) {
  .infobox {
    padding-top: 0px;
    z-index: 1;
  }

  .expand {
    display: inline;
  }
}

</style>
