<template>
  <div class="title_section">{{text}}</div>
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
    text: () -> kgl.parse(@config.text, @data)
}
</script>

<style scoped>
.title_section {
  font-size: 18px;
  padding: 0px 24px 0px 24px;
  color: rgba(0,0,0,0.54);
}

</style>
