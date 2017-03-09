<template>
  <div class="searchbar">
    <input class="search" type="text" placeholder="Cerca" @input="click_search" @keyup="change_selected_result">

    <div class="buttons">
      <button @click="click_search"><i class="icon-search"></i></button>
      <button v-if="mode === 'info'" @click="click_close"><i class="icon-x"></i></button>
      <button v-if="searchdirectionsbox_enabled && mode === 'fullmap'" @click="click_directions"><i class="icon-compass"></i></button>
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

  methods:
    click_close: () ->
      @$store.commit 'fullmap_mode'
      @$emit 'mobile_open', false
    click_directions: () -> @$store.dispatch 'request_directions', {def: true}
    click_search: () ->
      if d3.select('.search').node().value isnt ''
        @$emit 'search', d3.select('.search').node().value
      else
        @$emit 'search', undefined
    change_selected_result: (event) ->
      if event.key is 'ArrowDown'
        @$emit 'change_result', 1
      else if event.key is 'ArrowUp'
        @$emit 'change_result', -1
      else if event.key is 'Enter'
        @$emit 'change_result', 0

}
</script>

<style scoped>
.searchbar {
  background: #FFF;
  border-bottom: 1px solid lightgrey;
  border-radius: 3px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.2), 0 -1px 0px rgba(0,0,0,0.02);
  display: flex;
  flex-direction: row;
  align-items: center;
}
.icon-search, .icon-x {
  color: rgb(178, 178, 178);
  font-size: 16px;
  cursor: pointer;
}
.icon-compass {
  color: #b44646;
  cursor: pointer;
}
input {
  flex-grow: 1;
  width: 224px;
  height: 24px;
  margin-left: 30px;
  border: none;
  font-size: 15px;
  color: silver;
  border: none;
  outline: none;
}
input:active {
  border: none;
}

button {
  width: 50px;
  height: 25px;
  font-size: 20px;
  border: none;
  background: transparent;
}
.buttons {
  display: flex;
  align-items: center;
}
.buttons > *:not(:last-child) {
  border-right: 1px solid rgb(178, 178, 178);
}
</style>
