<template>
  <div class="text_section">
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
.text_section {
  padding: 24px;
  font-size: 13px;
  line-height: 19.5px;
  font-family: sans-serif;
  overflow: hidden;
}

</style>
