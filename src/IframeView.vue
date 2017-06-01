<template>
  <div class="iframeview">
    <spaceheader :overlay="true"></spaceheader>
    
    <iframe :src="url"></iframe>
  </div>
</template>

<script lang="coffee">
import SpaceHeader from './SpaceHeader.vue'

export default {
  props:
    url:
      type: String
  components:
    spaceheader: SpaceHeader
}
</script>

<style scoped>
.iframeview {
  width: 100%;
  height: 100%;

  display: flex;
  flex-direction: row;
}
iframe {
  flex-grow: 1;
  border: 0;
}
</style>
