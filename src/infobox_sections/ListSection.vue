<template>
  <table class="list_section">
    <tr v-for="item in config.items"><td class="label">{{item.label}}</td><td class="value">{{data[item.property]}}</td></tr>
  </table>
</template>

<script lang="coffee">
export default {
  props:
    data:
      type: Object
      required: true
    config:
      type: Object
      required: true
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
