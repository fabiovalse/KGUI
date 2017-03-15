<template>
  <div class="infobox">
    <div class="expand"><span v-if="mobile_open"><i class="icon-slide-down"></i></span><span v-else><i class="icon-slide-up"></i></span></div>
    <sections v-if="target !== undefined"></sections>
  </div>
</template>

<script lang="coffee">
import Sections from './infobox_sections/Sections.vue'

export default {
  props:
    searchdirectionsbox_enabled:
      type: Boolean
    mobile_open:
      type: Boolean
  computed:
    mode: () -> @$store.state.mode
    target: () -> @$store.state.target
  methods: # FIXME some methods are unused
    click_directions: () -> @$store.dispatch 'request_directions', {def: true}
    click_node: (d) -> @$store.dispatch 'select', {id: d.id}
  components:
    sections: Sections
}
</script>

<style scoped>
.infobox {
  box-shadow: 0 0 20px rgba(0,0,0,0.3);
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

/* Google-style scrollbar on webkit */
.infobox {
  overflow-x: hidden;
  overflow-y: hidden;
}
.infobox:hover {
  overflow-y: scroll;
}
::-webkit-scrollbar {
  width: 6px;
}
::-webkit-scrollbar-track {
  background: #EEE;
}
::-webkit-scrollbar-thumb {
  background: #888;
}

</style>
