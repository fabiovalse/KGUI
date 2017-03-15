<template>
  <div class="image_section">
    <img v-if="data[config.property] !== undefined" :src="data[config.property]"></img>
    <div v-if="data[config.property] === undefined" class="placeholder"></div>
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
.placeholder {
  width: 100%;
  height: 240px;
  background: #EEE;
}

</style>
