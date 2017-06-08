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
      v-if="mode !== undefined"
    ></resultsbox>
    <infobox
      class="box"
      :searchdirectionsbox_enabled="config.layout.searchdirectionsbox"
      :mobile_open="mobile_open"
      v-on:mobile_open="toggle_mobile_open"
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
    <breadcrumb
      :path="space.vfs_path"
      v-if="space !== undefined && space.vfs_enabled"
    ></breadcrumb>
  </div>
</template>

<script lang="coffee">
import View from './View.vue'
import SearchBar from './SearchBar.vue'
import ResultsBox from './ResultsBox.vue'
import InfoBox from './InfoBox.vue'
import SearchDirectionsBox from './SearchDirectionsBox.vue'
import Breadcrumb from './Breadcrumb.vue'
import config from './config.coffee'

export default {
  data: () ->
    mobile_open: false
    result_change: undefined

  computed:
    mode: () -> @$store.state.selection.mode
    config: () -> config

    # STORE -> ROUTER
    # read space and target as a reactive property
    space_target: () -> {
      space: @$store.state.selection.space_id
      target: @$store.state.selection.target_id
    }

    space_id: () -> @$store.state.selection.space_id
    target_id: () -> @$store.state.selection.target_id

    space: () -> @$store.state.selection.space

  mounted: () ->
    # @$store.dispatch 'init', {default_starting_point: config.default_starting_point, default_space: config.default_space}
    @route_changed @$route # ROUTER -> STORE

  watch:
    $route: (to, from) -> @route_changed(to) # ROUTER -> STORE
    
    # STORE -> ROUTER
    space_target: (ids) ->
      if not ids.space?
        throw 'Assertion error: a space ID must always be defined'
      if not ids.target?
        @$router.push
          name: 'goto_space',
          params:
            space: ids.space
      else
        @$router.push
          name: 'goto_space_target',
          params:
            space: ids.space
            target: ids.target

    # data loading
    space_id: (id) -> @$store.dispatch 'load_space', id
    target_id: (id) ->
      if id?
        @$store.dispatch 'load_target', id
      else
        @$store.commit 'clear_target'

  methods:
    toggle_mobile_open: (flag) ->
      @mobile_open = if flag? then flag else (not @mobile_open)

    # ROUTER -> STORE
    route_changed: (route) ->
      switch route.name
        when 'goto_space'
          @$store.commit 'goto_space', route.params.space
        when 'goto_space_target'
          @$store.commit 'goto_space_target', {
            space: route.params.space
            target: route.params.target
          }
        when 'goto_target'
          @$store.commit 'goto_target', route.params.target

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
    breadcrumb: Breadcrumb
}
</script>

<style>
html, body {
  width: 100%;
  height: 100%;
  padding: 0;
  margin: 0;
  overflow: hidden;
  font-family: Roboto, Arial, sans-serif;
}
#app {
  width: 100%;
  height: 100%;
  overflow: hidden;
  --main-bar-height: 64px;
  --left-panel-width: 408px;
  --main-color: #B44646;
  --left-panel-scrollbar-width: 6px;
  --paper-color: rgb(255, 246, 235);
}
.box {
  width: var(--left-panel-width);
}

.resultsbox1 {
  position: absolute;
  top: 54px;
  left: 8px;
  width: 386px;
  z-index: 10;
  box-shadow: 0 2px 4px rgba(0,0,0,0.2), 0 -1px 0px rgba(0,0,0,0.02);
}
.resultsbox2 {
  position: absolute;
  top: 125px;
  left: 0;
  z-index: 7;
}
.searchdirectionsbox {
  position: absolute;
  height: 100px;
  background: #B44646;
}
.mainview {
  position: absolute;
  top: var(--main-bar-height);
  left: 0;
  box-sizing: border-box;
  width: 100%;
  height: calc(100% - var(--main-bar-height));
  background: #f5f5f5;
}

a {
  color: #B44646;
  text-decoration: none;
}
a:hover {
  text-decoration: underline;
}

sup {
  font-size: 12px;
  color: #B44646;
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
