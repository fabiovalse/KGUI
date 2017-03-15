<template>
  <div class="list_section">
    <table v-if="items.length > 0">
      <tr v-for="item in items"><td class="label" v-html="item.label"></td><td class="value" v-html="item.value"></td></tr>
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
}

td:not(:last-child) {
  padding-right: 8px;
}

</style>
