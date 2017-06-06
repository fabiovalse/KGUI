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
  margin: 0px 0px 20px 0px;
}

</style>

<style>
.infobox .title_section {
  font-size: 18px;
  color: rgba(0,0,0,0.54);
}

.infoview .title_section {
  font-size: 20px;
  font-weight: 300;
}

</style>
