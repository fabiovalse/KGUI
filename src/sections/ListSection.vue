<template>
  <div class="list_section">
    <titlesubsection v-if="items.length > 0 && config.title !== undefined" :text="config.title"></titlesubsection>
    <table v-if="items.length > 0">
      <tr v-if="item.value != ''" v-for="item in items">
        <td v-if="item.icon != undefined">
          <i :class="'icon icon-' + item.icon" :title="item.label"></i>
        </td>
        <td v-else class="value" v-html="item.label"></td>
        <td class="value" v-html="item.value"></td>
      </tr>
    </table>
  </div>
</template>

<script lang="coffee">
import kgl from './kgl.coffee'
import TitleSubSection from './TitleSubSection.vue'

export default {
  props:
    data:
      type: Object
      required: true
    config:
      type: Object
      required: true
  
  computed:
    items: () ->
      list = @config.items.map (item) => 
        x = {
          label: kgl.parse(item.label, @data)
          value: @to_html(kgl.parse(item.value, @data))
          icon: item.icon
        }
        console.log x
        console.log ""
        return x

      # keep defined pairs only
      return list.filter (d) -> d.label? and d.value?

  methods:
    to_html: (value) ->
      #console.log value
      if typeof value is 'object'
        return value.map((v) -> "<div class='item'>#{v}</div>").join('')
      else
        return value

  components:
    titlesubsection: TitleSubSection
}
</script>

<style scoped>
table {
  padding: 16px;
  border-collapse: separate;
  border-spacing: 8px;
  width: 100%;
}
table td {
  word-wrap: break-word;
}
td:not(:last-child) {
  padding-right: 8px;
}

.icon {
  font-size: 18px;
  color: #B44646;
}
</style>

<style>
.infobox table {
  font-size: 13px;
}
.infoview table {
  font-size: 15px;
  font-weight: 300;
}

.list_section .item {
  margin-bottom: 2px
}
</style>
