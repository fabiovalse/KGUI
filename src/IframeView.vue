<template>
  <div class="iframeview">
    <iframe :src="url"></iframe>
  </div>
</template>

<script lang="coffee">
export default {
  props:
    url:
      type: String
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
