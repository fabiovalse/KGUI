<template>
  <div class="searchbar" :class="{focused: focused}">
    <div class="innerbar">
      <input
        class="search"
        type="text"
        placeholder="Search"
        @input="click_search"
        @keyup.down="change_result(1)"
        @keyup.up="change_result(-1)"
        @keyup.enter="change_result(0)"
        @focus="focus"
        @blur="blur"
        :value="get_target()">

      <button @click="click_search"><i class="icon-search"></i></button>
      <div v-if="searchdirectionsbox_enabled && mode === undefined" class="separator"></div>
      <button v-if="searchdirectionsbox_enabled && mode === undefined" @click="click_directions"><i class="icon-directions"></i></button>
    </div>
  </div>
</template>

<script lang="coffee">
export default {
  data: () ->
    focused: false

  props:
    searchdirectionsbox_enabled:
      type: Boolean

  computed:
    mode: () -> @$store.state.selection.mode
    space: () -> @$store.state.selection.space
    target: () -> @$store.state.selection.target

  methods:
    click_close: () ->
      @$store.commit 'set_mode', undefined
      @$emit 'mobile_open', false
    click_directions: () -> @$store.commit 'goto_directions', {
      space: @space.id # FIXME this should be removed
      from: '_'
      to: if @target? then @target.id else '_'
    }
    click_search: () ->
      @$emit 'search', d3.select('.search').node().value
    change_result: (value) ->
      @$emit 'change_result', value
    get_target: () -> 
      if @target isnt undefined
        @target.label
      else ''
    focus: () -> @focused = true
    blur: () -> @focused = false

}
</script>

<style scoped>
.searchbar {
  position: absolute;
  top: 8px;
  left: 8px;
  
  z-index: 10;
}
.innerbar {
  width: var(--left-margined-panel-width);
  height: calc(var(--main-bar-height) - 16px);
  background: #F5F5F5;
  border-radius: 3px;
  display: flex;
  flex-direction: row;
  align-items: center;
  outline: none;
}
.searchbar.focused .innerbar {
  background: white;
  box-shadow: var(--box-shadow);
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
  outline: none;
}
.separator {
  height: 60%;
  border-right: 1px solid rgb(178, 178, 178);
}

@media (max-width: 480px) {
  .mobile_open .searchbar {
    display: none;
  }

  .innerbar {
    width: 100%;
  }
}

</style>
<style>
#app:not(.vfs_enabled) .searchbar .innerbar {
  box-shadow: 2px 2px 7px rgba(0,0,0,0.25);
}
</style>