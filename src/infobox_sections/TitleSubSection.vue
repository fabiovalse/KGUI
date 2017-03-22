<template>
  <div class="title_section" v-html="title"></div>
</template>

<script lang="coffee">
import kgl from './kgl.coffee'

export default {
  props: ['text']

  computed:
    title: () -> kgl.parse(@text)
}
</script>

<style scoped>
.title_section {
  font-size: 18px;
  padding-bottom: 15px;
  color: rgba(0,0,0,0.54);
}

</style>
