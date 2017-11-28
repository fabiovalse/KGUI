<template>  
  <table v-if="results !== undefined" class="resultsbox">
    <tr 
      class="result"
      v-for="(r,i) in results"
      @click="click_node(r)"
      :class="{selected: i == selected}"
    >
      <td class="icon"><i :class="'icon-'+get_icon(r)"></i></td>
      <td class="label">
        <span class="main">{{r.label}}</span>
        <span class="info">{{get_info(r)}}</span>
      </td>
    </tr>
  </table>
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
          else if new_change.value is 0 # Enter
            @$store.dispatch 'select', {d: @results[@selected], directions_input: @directions_input}
              
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
      @results = undefined
      @$store.dispatch 'select', {d: d, directions_input: @directions_input}

    get_icon: (d) ->
      switch d.template
        when 'person' then 'user'
        else 'placemark'

    get_info: (d) ->
      switch d.template
        when 'person' then "#{d.institute.label} - #{d.group[0].label}"
        when 'room' then "Edificio #{d.building}, ingresso #{d.entrance}, piano #{d.floor}"
        else ''

    search_node: (str, directions_input) ->
      if str isnt ''
        @directions_input = directions_input

        db.query_node str, (data) => @results = data
      else
        @$store.dispatch 'select', {d: {_key: '_'}, directions_input: @directions_input}
        @results = undefined

}
</script>

<style scoped>
.resultsbox {
  background: #FFF;
  border-collapse: collapse;
  width: var(--left-margined-panel-width);
  table-layout: fixed;
}
.resultsbox td {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.result {
  height: 43px;
  width: var(--left-margined-panel-width);
  cursor: pointer;
}
.result:hover {
  background: #F2F2F2;
}
.selected {
  background: #F2F2F2;
}

.result .icon {
  width: 60px;
  text-align: center;
  font-size: 14px;
  color: rgb(178, 178, 178);
}
.result .label {
  width: calc(var(--left-margined-panel-width) - 80px);
  font-size: 12px;
  border-bottom: 1px solid rgb(230, 230, 230);
  padding-right: 12px;
}
.result .label .main {
  font-weight: bold; 
}
.result .label .info {
  font-weight: 400;
  color: #8C8C8C;
}

@media (max-width: 480px) {
  .result {
    margin-left: 0px;
    padding-left: 10px;
  }
  .mobile_open .result {
    display: none;
  }
}
</style>
