<template>
  <div class="imageview">
    <img :src="url" />
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
.imageview {
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
}

img {
  max-height: 400px;
}
</style>
