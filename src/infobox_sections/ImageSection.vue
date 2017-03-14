<template>
  <div class="image_section">
    <img v-if="data[config.property] !== undefined" :src="data[config.property]"></img>
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
.image_section {
  width: 100%;
}

img {
  width: 100%;
  display: block;
}

</style>
