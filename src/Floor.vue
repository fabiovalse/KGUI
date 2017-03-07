<template>
  <g v-html="group"></g>
</template>

<script lang="coffee">
export default {
  props: ['data']

  data: () ->
    group: ''
  
  mounted: () ->
    d3.text "data/#{@data.urls.slice(-1)[0]}", (result) =>
      @group = result

}
</script>

<style scoped>

</style>
