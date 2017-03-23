<template>
  <div id="app" :class="{mobile_open: mobile_open}">
    <searchbar
      :searchdirectionsbox_enabled="config.layout.searchdirectionsbox"
      v-on:change_result="change_result"
      v-on:search="search"
      v-on:mobile_open="toggle_mobile_open"
      v-if="config.layout.searchbar && mode !== 'directions'"
    ></searchbar>
    <resultsbox
      class="resultsbox1"
      ref="resultsbox1"
      :result_change="result_change"
    ></resultsbox>
    <resultsbox
      class="resultsbox2 box"
      ref="resultsbox2"
      :result_change="result_change"
      v-if="mode !== 'fullmap'"
    ></resultsbox>
    <infobox
      class="box"
      :searchdirectionsbox_enabled="config.layout.searchdirectionsbox"
      :mobile_open="mobile_open"
      v-on:mobile_open="toggle_mobile_open"
      v-if="config.layout.infobox && mode !== 'fullmap'"
    ></infobox>
    <searchdirectionsbox
      ref="searchdirectionsbox"
      class="box"
      v-on:search="search"
      v-on:change_result="change_result"
      v-if="config.layout.searchdirectionsbox && mode === 'directions'"
    ></searchdirectionsbox>
    <mainview
      :config="config"
      v-if="config.layout.view"
    ></mainview>
  </div>
</template>

<script lang="coffee">
import View from './View.vue'
import SearchBar from './SearchBar.vue'
import ResultsBox from './ResultsBox.vue'
import InfoBox from './InfoBox.vue'
import SearchDirectionsBox from './SearchDirectionsBox.vue'
import config from './config.coffee'

export default {
  data: () ->
    mobile_open: false
    result_change: undefined

  computed:
    mode: () -> @$store.state.mode
    config: () -> config

  mounted: () ->
    @$store.dispatch 'init', {default_starting_point: config.default_starting_point, default_space: config.default_space}
    @route_changed @$route

  watch:
    $route: (to, from) -> @route_changed(to)

  methods:
    toggle_mobile_open: (flag) ->
      @mobile_open = if flag? then flag else (not @mobile_open)

    route_changed: (route) ->      
      if route.params.target?
        @$store.dispatch 'request_info', route.params.target
      else if 'from' in Object.keys(route.params) and 'to' in Object.keys(route.params)
        @$store.dispatch 'request_directions', {
          from_id: (if route.params.from is '_' then undefined else route.params.from),
          to_id: (if route.params.to is '_' then undefined else route.params.to),
        }

    search: (str) ->
      if @mode is 'directions'
        @$refs.resultsbox2.search_node str, @$refs.searchdirectionsbox.current_input
      else
        @$refs.resultsbox1.search_node str

    change_result: (value) ->
      @result_change = {value: value}

  components:
    infobox: InfoBox
    searchdirectionsbox: SearchDirectionsBox
    searchbar: SearchBar
    mainview: View
    resultsbox: ResultsBox
}
</script>

<style>
html, body {
  width: 100%;
  height: 100%;
  padding: 0;
  margin: 0;
  overflow: hidden;
  font-family: Roboto, sans-serif;
}
#app {
  width: 100%;
  height: 100%;
  overflow: hidden;
}
.box {
  width: 408px;
}

.searchbar {
  position: absolute;
  top: 10px;
  left: 10px;
  z-index: 10;
  height: 48px;
  width: 390px;
}
.resultsbox1 {
  position: absolute;
  top: 59px;
  left: 10px;
  width: 390px;
  z-index: 10;
  box-shadow: 0 2px 4px rgba(0,0,0,0.2), 0 -1px 0px rgba(0,0,0,0.02);
}
.resultsbox2 {
  position: absolute;
  top: 125px;
  left: 0;
  z-index: 2;
}
.infobox {
  position: absolute;
  height: 100%;
  background: #FFF;
}
.searchdirectionsbox {
  position: absolute;
  height: 100px;
  background: #B44646;
}
.mainview {
  width: 100%;
  height: 100%;
}

a {
  color: #B44646;
  text-decoration: none;
}
a:hover {
  text-decoration: underline;
}

sup {
  font-size: 8px;
  position: absolute;
  margin-top: -5px;
  margin-left: -2px;
}

@media (max-width: 480px) {
  #app {
    position: absolute;
  }

  .box {
    width: 100%;
  }

  .searchbar {
    top: 10px;
    left: 2.5%;
    width: 95%;
  }

  .resultsbox1, .resultsbox2 {
    font-size: 15px;
  }

  .resultsbox1 {
    width: 95%;
  }

  .resultsbox2 {
    width: 100%;
    top: 110px;

  }

  .infobox {
    top: 100%;
    margin-top: -80px;
  }

}
</style>
