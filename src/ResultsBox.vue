<template>
  <div v-if="results !== undefined" class="resultsbox">
    <div class="result" :class="{selected: i == selected}" v-for="(r,i) in results" @click="click_node(r)">
      {{r.label}}
    </div>
  </div>
</template>

<script lang="coffee">
import db from './database.coffee'

export default {
  
  props: ['result_change']

  data: () ->
    results: undefined
    directions_input: undefined
    selected: undefined

  watch:
    result_change: (new_change, old_change) ->
      if @results isnt undefined
        if @selected?
          if (@selected is @results.length-1 and new_change.value is 1) or (@selected is 0 and new_change.value is -1)
            @selected = undefined
          else if new_change.value is 0
            @$store.dispatch 'select', {id: @results[@selected].id, directions_input: @directions_input}
            @results = undefined
            @selected = undefined
          else
            @selected += new_change.value
        else if new_change.value is 1
          @selected = 0
        else if new_change.value is -1
          @selected = @results.length-1

  methods:
    click_node: (d) -> 
      @$store.dispatch 'select', {id: d.id, directions_input: @directions_input}
      @results = undefined

    search_node: (str, directions_input) ->
      @directions_input = directions_input
      
      db.query_node str, ((data) =>
        result = JSON.parse(data.responseText)

        @results = result.data.map (n) ->
          node = n[0].data
          node.id = n[0].metadata.id
          node.labels = n[0].metadata.labels 
          return node)

}
</script>

<style scoped>
.resultsbox {
  background: #FFF; 
}
.result {
  display: flex;
  align-items: center;
  height: 43px;
  border-bottom: 1px solid rgb(230, 230, 230);
  cursor: pointer;
  padding-left: 30px;
}
.result:hover {
  background: #F2F2F2;
}
.selected {
  background: #F2F2F2; 
}

@media (max-width: 480px) {
  .result {
    margin-left: 0px;
    padding-left: 10px;
  }
}
</style>
