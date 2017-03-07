<template>
  <div class="iframeview">
    <iframe src="http://wafi.iit.cnr.it/webvis/lab/public/b755da34ae8f5a65c7c8/"></iframe>
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
  }
  iframe {
        width: 100%;
    height: 100%;
  }
</style>
