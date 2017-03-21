<template>
  <div class="list_section">
    <table v-if="items.length > 0">
      <tr v-for="item in items">
        <td v-if="item.icon != undefined">
          <i :class="'icon icon-' + item.icon"></i>
        </td>
        <td v-else class="value" v-html="item.label"></td>
        <td class="value" v-html="item.value"></td>
      </tr>
    </table>
  </div>
</template>

<script lang="coffee">
import kgl from './kgl.coffee'

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
      list = @config.items.map (item) => {
        label: kgl.parse(item.label, @data)
        value: kgl.parse(item.value, @data)
        icon: item.icon
      }

      # keep defined pairs only
      return list.filter (d) -> d.label? and d.value?

}
</script>

<style scoped>
table {
  padding: 16px;
  font-size: 13px;
  font-family: sans-serif;
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
.list_section .item {
  margin-bottom: 2px
}
</style>
