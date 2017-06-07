<template>
  <div class="infobox" :class="{mobile_open: mobile_open}">
    <v-touch tag="div" class="expand" v-on:swipe="click"><span @click="click" v-if="mobile_open"><i class="icon-slide-down"></i></span><span @click="click" v-else><i class="icon-slide-up"></i></span>
    </v-touch>

    <sections v-if="target !== undefined"></sections>
    <directionsinfo v-if="mode === 'directions'"></directionsinfo>
    <button class="close_button" @click="click_close"><i class="icon-x"></i></button>
  </div>

</template>

<script lang="coffee">

import Sections from './infobox_sections/Sections.vue'
import DirectionsInfo from './DirectionsInfo.vue'

export default {
  props:
    searchdirectionsbox_enabled:
      type: Boolean
    mobile_open:
      type: Boolean
  computed:
    mode: () -> @$store.state.selection.mode
    target: () -> @$store.state.selection.target
  methods: # FIXME some methods are unused
    click_directions: () -> @$store.dispatch 'request_directions', {def: true}
    click_node: (d) -> @$store.dispatch 'select', {id: d.id}
    click: (e) ->
      d3.select(@$el)._groups[0][0].scrollTop = 0
      @$emit 'mobile_open'
    click_close: () ->
      @$store.commit 'set_mode', undefined
      @$emit 'mobile_open', false
  components:
    sections: Sections
    directionsinfo: DirectionsInfo

}
</script>

<style scoped>
.infobox {
  --margin: 17px;
  --radius: 3px;
  position: absolute;
  top: calc(var(--main-bar-height) + var(--margin));
  left: var(--margin);
  width: calc(var(--left-panel-width) - 2 * var(--margin) - 6px);
  max-height: calc(100% - var(--main-bar-height) - 2 * var(--margin));
  z-index: 5;
  background: #FFF;
  border-radius: var(--radius);
  box-shadow: 1px 1px 12px rgba(0,0,0,0.8);
  box-sizing: border-box;
}

.mobile_open {
  top: 0%;
  margin-top: 0px;
}
.expand {
  position: absolute;
  margin-top: 10px;
  display: none;
  text-align: center;
  width: 100%;
  background: transparent;
  z-index: 10;
}
.expand i {
  color: #fff;
}

.close_button {
  position: absolute;
  top: 15px;
  right: 10px;
  background: transparent;
  border: none;
  color: #FFF;
  text-shadow: #000 0px 0px 6px;
  font-size: 15px;
  cursor: pointer;
}

/* Google-style scrollbar on webkit */
.infobox {
  overflow-x: hidden;
}
::-webkit-scrollbar {
  width: var(--left-panel-scrollbar-width);
}
::-webkit-scrollbar-track {
  background: #EEE;
  border-top-right-radius: var(--radius);
  border-bottom-right-radius: var(--radius);
}
::-webkit-scrollbar-thumb {
  background: #888;
  border-top-right-radius: var(--radius);
  border-bottom-right-radius: var(--radius);
}

@media (max-width: 480px) {
  .infobox {
    padding-top: 0px;
    z-index: 1;
    transition: top 1s;
    -webkit-transition: top 1s;
    -moz-transition: top 1s;
  }
  .expand {
    display: block;
    height: 80px;
  }
  :not(.mobile_open) {
    overflow-y: hidden !important;
  }
  .mobile_open .expand {
    z-index: 10;
  }
}
</style>
