<template>
  <div id="app" :class="{mobile_open: mobile_open, vfs_enabled: vfs_enabled}">
    <breadcrumb
      :path="space.vfs_path"
      v-if="vfs_enabled"
    ></breadcrumb>
    
    <searchbar
      :searchdirectionsbox_enabled="config.layout.searchdirectionsbox"
      v-on:change_result="change_result"
      v-on:search="search"
      v-on:mobile_open="toggle_mobile_open"
      v-if="mode === 'target' || mode === 'space'"
    ></searchbar>
    <resultsbox
      class="resultsbox_target box"
      ref="resultsbox_target"
      :result_change="result_change"
    ></resultsbox>

    <searchdirectionsbox
      ref="searchdirectionsbox"
      class="box"
      v-on:search="search"
      v-on:change_result="change_result"
      v-if="mode === 'directions'"
    ></searchdirectionsbox>
    <resultsbox
      class="resultsbox_directions box"
      ref="resultsbox_directions"
      :result_change="result_change"
    ></resultsbox>
    
    <infobox
      class="box"
      :searchdirectionsbox_enabled="config.layout.searchdirectionsbox"
      :mobile_open="mobile_open"
      v-on:mobile_open="toggle_mobile_open"
    ></infobox>
    
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
import Breadcrumb from './Breadcrumb.vue'
import config from './config.coffee'

export default {
  data: () ->
    mobile_open: false
    result_change: undefined

  computed:
    mode: () -> @$store.getters.mode

    config: () -> config

    # STORE -> ROUTER
    # read the selection state as a single reactive property
    selection_state: () -> {
      space: @$store.state.selection.space_id
      target: @$store.state.selection.target_id
      from: @$store.state.selection.from_id
      to: @$store.state.selection.to_id
    }

    space_id: () -> @$store.state.selection.space_id
    target_id: () -> @$store.state.selection.target_id
    from_to_ids: () -> {
      from: @$store.state.selection.from_id
      to: @$store.state.selection.to_id
    }

    space: () -> @$store.state.selection.space
    vfs_enabled: () -> @space? and @space.vfs_enabled

  mounted: () ->
    # @$store.dispatch 'init', {default_starting_point: config.default_starting_point, default_space: config.default_space}
    @route_changed @$route # ROUTER -> STORE

  watch:
    $route: (to, from) -> @route_changed(to) # ROUTER -> STORE
    
    # STORE -> ROUTER
    selection_state: (ids) -> 
      if not ids.space?
        throw 'Assertion error: a space ID must always be defined'
      if ids.target?
        @$router.push
          name: 'goto_space_target',
          params:
            space: ids.space
            target: ids.target
      else
        if ids.from? and ids.to?
          @$router.push
            name: 'goto_directions',
            params: ids
        else
          @$router.push
            name: 'goto_space',
            params:
              space: ids.space

    # data loading
    space_id: (id) -> @$store.dispatch 'load_space', id
    target_id: (id) ->
      if id?
        @$store.dispatch 'load_target', id
      else
        @$store.commit 'unload_target'
    from_to_ids: (ids) ->
      if ids.from? and ids.to?
        @$store.dispatch 'load_directions', ids
      else
        @$store.commit 'unload_directions'

  methods:
    toggle_mobile_open: (flag) ->
      @mobile_open = if flag? then flag else (not @mobile_open)

    # ROUTER -> STORE
    route_changed: (route) -> # FIXME: this function could be improved by avoiding multiple calls (such as committing a "goto mutation" from console)
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
        when 'goto_directions'
          @$store.commit 'goto_directions', route.params

    search: (str) ->
      if @mode is 'directions'
        @$refs.resultsbox_directions.search_node str, @$refs.searchdirectionsbox.current_input
      else
        @$refs.resultsbox_target.search_node str

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
  --left-margined-panel-width: calc(var(--left-panel-width) - 16px - var(--left-panel-scrollbar-width));
  --box-shadow: 2px 2px 7px rgba(0,0,0,0.25);
}
.box {
  width: var(--left-margined-panel-width);
}

.resultsbox_target {
  position: absolute;
  top: 54px;
  left: 8px;
  width: var(--left-margined-panel-width);
  box-shadow: var(--box-shadow);

  z-index: 10;
}
.resultsbox_directions {
  position: absolute;
  top: 111px;
  left: 8px;
  width: var(--left-margined-panel-width);
  box-shadow: var(--box-shadow);

  z-index: 10;
}
.searchdirectionsbox {
  position: absolute;
  height: 100px;
  background: #B44646;
}
.mainview {
  position: absolute;
  top: 0;
  left: 0;
  box-sizing: border-box;
  width: 100%;
  height: 100%;
  background: #fcfaf6;
}
.vfs_enabled .mainview {
  top: var(--main-bar-height);
  height: calc(100% - var(--main-bar-height));
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

  .resultsbox_target, .resultsbox_directions {
    font-size: 15px;
  }

  .resultsbox_target {
    width: 95%;
  }

  .resultsbox_directions {
    width: 100%;
    top: 110px;

  }

  .infobox {
    top: 100%;
    margin-top: -80px;
  }

}
</style>
