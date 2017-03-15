<template>
  <table class="list_section">
    <tr v-for="item in items"><td class="label">{{item.label}}</td><td class="value">{{item.value}}</td></tr>
  </table>
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
      return @config.items.map (item) =>
        label = kgl.parse(item.label, @data)
        value = kgl.parse(item.value, @data)
        return {
          label: if label? then label else ''
          value: if value? then value else ''
        }
}
</script>

<style scoped>
.list_section {
  padding: 16px;
  font-size: 13px;
  font-family: sans-serif;
  border-collapse: separate;
  border-spacing: 8px;
}

.label {
  font-weight: bold;
}

td:not(:last-child) {
  padding-right: 8px;
}

</style>
