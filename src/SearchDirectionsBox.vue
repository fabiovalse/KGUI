<template>
  <div class="searchdirectionsbox">
    <button class="close" @click="close"><i class="icon-x"></i></button>
    <div class="from_to">
      <div class="from">
        <input 
          type="text"
          :value="from ? from.label : ''"
          placeholder="Scegli punto di partenza"
          @input="search_from"
          @click="set_current_input('from')"
          @keyup="change_selected_result"
        >
        <button v-if="current_input == 'from'" @click="search_from"><i class="icon-search"></i></button>
      </div>
      <div class="to">
        <input 
          type="text"
          :value="to ? to.label : ''"
          placeholder="Scegli punto di arrivo"
          @input="search_to"
          @click="set_current_input('to')"
          @keyup="change_selected_result"
        >
        <button v-if="current_input == 'to'" @click="search_to"><i class="icon-search"></i></button>
      </div>
    </div>
  </div>
</template>

<script lang="coffee">
export default {

  data: () ->
    current_input: undefined

  computed:
    from: () -> @$store.state.selection.directions.from
    to: () -> @$store.state.selection.directions.to
  
  methods:
    close: () -> @$store.commit 'clear'
    
    search_from: () ->
      @current_input = 'from'
      @$emit 'search', d3.select('.from input').node().value
    
    search_to: () ->
      @current_input = 'to'
      @$emit 'search', d3.select('.to input').node().value
    
    set_current_input: (input) ->
      @current_input = input

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
.searchdirectionsbox {
  --radius: 3px;
  position: absolute;
  top: 8px;
  left: 8px;
  height: 105px;
  border-radius: var(--radius);
  box-shadow: var(--box-shadow);

  z-index: 10;
}

.icon-search, .icon-x {
  color: #FFF;
  font-size: 16px;
  cursor: pointer;
}
.close {
  position: absolute;
  top: 12px;
  right: 16px;
}

button {
  width: 24px;
  height: 24px;
  font-size: 20px;
  border: none;
  background: transparent;
}

input {
  width: 264px;
  height: 24px;
  background: transparent;
  border: none;
  color: #FFF;
  font-size: 15px;
  outline: none;
}

.from, .to {
  display: flex;
  width: 280px;
  align-items: center;
  border-bottom: 1px solid rgba(255,255,255,0.6);
}
.from {
  margin-bottom: 15px;
}

.from_to {
  margin: 12px 0px 0px 30px;
}

/*  Input placeholder color
*/
::-webkit-input-placeholder {
  color: #D5D5D5;
}
:-moz-placeholder {
   color: #D5D5D5;
   opacity:  1;
}
::-moz-placeholder {
   color: #D5D5D5;
   opacity:  1;
}
:-ms-input-placeholder {
   color: #D5D5D5;
}
::-ms-input-placeholder {
   color: #D5D5D5;
}

@media (max-width: 480px) {
  .mobile_open .searchdirectionsbox {
    display: none;
  }

  .close {
    top: 10px;
    right: 10px;
  }
  
  .from_to {
    margin: 20px 0px 0px 20px;
  }

  .searchdirectionsbox {
    height: 110px;
    top: 0;
    left: 0;
  }
}
</style>