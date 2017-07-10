<template>
  <div class="imagesection">
    <img :src="url" />
  </div>
</template>

<script lang="coffee">
import kgl from '../infobox_sections/kgl.coffee'

export default {
  props:
    data:
      type: Object
      required: true
    config:
      type: Object
      required: true

  mounted: () ->
    @$el.style.setProperty '--img-width', if @config.width? then @config.width else "100%"

  computed:
    url: () -> kgl.parse(@config.href, @data, false)

}
</script>

<style scoped>
.imagesection {
  margin-top: 20px;
  text-align: center;
}
.imagesection img {
  width: var(--img-width);
  border-radius: 2px;
}
</style>
