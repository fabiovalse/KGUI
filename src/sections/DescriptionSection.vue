<template>
  <div class="descriptionsection" v-html="text"></div>
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
.descriptionsection {
  margin-top: 20px;
  font-size: 16px;
  font-weight: 300;
  line-height: 1.2em;
  color: black;
}
</style>
