<template>
  <div class="infobox" :class="{mobile_open: mobile_open}">
    <div class="top_band"></div>
    <v-touch tag="div" class="expand" v-on:swipe="click"><span @click="click" v-if="mobile_open"><i class="icon-slide-down"></i></span><span @click="click" v-else><i class="icon-slide-up"></i></span>
    </v-touch>

    <sections v-if="target !== undefined"></sections>
    <directionsinfo v-if="mode === 'directions'"></directionsinfo>
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
    mode: () -> @$store.state.mode
    target: () -> @$store.state.target
  methods: # FIXME some methods are unused
    click_directions: () -> @$store.dispatch 'request_directions', {def: true}
    click_node: (d) -> @$store.dispatch 'select', {id: d.id}
    click: (e) ->
      d3.select(@$el)._groups[0][0].scrollTop = 0
      @$emit 'mobile_open'
  components:
    sections: Sections
    directionsinfo: DirectionsInfo

}
</script>

<style scoped>
.top_band {
  width: 100%;
  height: var(--main-bar-height);
  background: var(--main-color);
}

.infobox {
  position: absolute;
  top: 0;
  height: 100%;
  background: #FFF;
  z-index: 6;
  box-shadow: 0 0 18px rgba(0,0,0,0.8);
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

/* Google-style scrollbar on webkit */
.infobox {
  overflow-x: hidden;
  overflow-y: scroll;
}
::-webkit-scrollbar {
  width: var(--left-panel-scrollbar-width);
}
::-webkit-scrollbar-track {
  background: #EEE;
}
::-webkit-scrollbar-thumb {
  background: #888;
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
