<template>
  <div class="header_section">
    {{data[config.property]}}
  </div>
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
.header_section {
  padding: 24px;
  font-size: 21px;
  font-family: sans-serif;
  background: #B44646;
  color: white;
}

</style>
