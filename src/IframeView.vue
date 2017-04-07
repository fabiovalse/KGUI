<template>
  <div class="iframeview">
    <div class="padding"></div>
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
.padding {
  width: 408px;
  background: gray;
}
iframe {
  flex-grow: 1;
  border: 0;
}
</style>
