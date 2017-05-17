<template>
  <div class="searchbar" :class="{targetdefined: target !== undefined}">
    <div class="innerbar">
      <input class="search" type="text" placeholder="Search" @input="click_search" @keyup="change_selected_result" :value="get_target()">

      <button @click="click_search"><i class="icon-search"></i></button>
      <div v-if="mode === 'info' || (searchdirectionsbox_enabled && mode === 'fullmap')" class="separator"></div>
      <button v-if="mode === 'info'" @click="click_close"><i class="icon-x"></i></button>
      <button v-if="searchdirectionsbox_enabled && mode === 'fullmap'" @click="click_directions"><i class="icon-directions"></i></button>
    </div>
  </div>
</template>

<script lang="coffee">
export default {

  props:
    searchdirectionsbox_enabled:
      type: Boolean

  computed:
    mode: () -> @$store.state.mode
    target: () -> @$store.state.target

  methods:
    click_close: () ->
      @$store.commit 'fullmap_mode'
      @$emit 'mobile_open', false
    click_directions: () -> @$store.dispatch 'request_directions', {def: true}
    click_search: () ->
      @$emit 'search', d3.select('.search').node().value
    change_selected_result: (event) ->
      if event.key is 'ArrowDown'
        @$emit 'change_result', 1
      else if event.key is 'ArrowUp'
        @$emit 'change_result', -1
      else if event.key is 'Enter'
        @$emit 'change_result', 0
    get_target: () -> 
      if @target isnt undefined
        @target.label
      else ''

}
</script>

<style scoped>
.searchbar {
  position: absolute;
  top: 0;
  left: 0;
  z-index: 10;
  height: var(--main-bar-height);
  width: calc(var(--left-panel-width) - var(--left-panel-scrollbar-width));
}
.searchbar.targetdefined {
  background: var(--main-color);
}
.innerbar {
  position: absolute;
  top: 8px;
  left: 8px;
  width: calc(var(--left-panel-width) - 16px - var(--left-panel-scrollbar-width));
  height: calc(var(--main-bar-height) - 16px);
  background: #F5F5F5;
  border-radius: 3px;
  /*box-shadow: 0 2px 4px rgba(0,0,0,0.2), 0 -1px 0px rgba(0,0,0,0.02);*/
  display: flex;
  flex-direction: row;
  align-items: center;
  outline: none;
}
.icon-search, .icon-x {
  color: rgb(178, 178, 178);
  cursor: pointer;
}
.icon-search {
  font-size: 18px;
}
.icon-x {
  font-size: 15px;
}
.icon-directions {
  color: #00B3FD;
  font-size: 19px;
  cursor: pointer;
}
input {
  flex-grow: 1;
  width: 224px;
  height: 24px;
  margin-left: 30px;
  border: none;
  font-size: 15px;
  border: none;
  outline: none;
  background: none;
}
input:active {
  border: none;
}

button {
  width: 52px;
  height: 50%;
  border: none;
  background: transparent;
}
.separator {
  height: 60%;
  border-right: 1px solid rgb(178, 178, 178);
}

@media (max-width: 480px) {
  .mobile_open .searchbar {
    display: none;
  }
}

</style>
