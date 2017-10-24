<template>
  <g v-html="group"></g>
</template>

<script lang="coffee">
export default {
  props: ['data']

  data: () ->
    group: ''
  
  mounted: () ->
    d3.text "#{@data.url}", (result) =>
      @group = result

}
</script>

<style scoped>

</style>
