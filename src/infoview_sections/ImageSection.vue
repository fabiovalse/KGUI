<template>
  <div v-if="url" class="imagesection">
    <img :src="url" />
    <p v-if="caption !== undefined" class="caption">{{caption}}</p>
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
    if @url?
      @$el.style.setProperty '--img-width', if @config.width? then @config.width else "100%"

  computed:
    url: () -> kgl.parse(@config.href, @data, false)
    caption: () -> kgl.parse(@config.caption, @data)

}
</script>

<style scoped>
.imagesection {
  padding-top: 20px;
  text-align: center;
}
.imagesection img {
  width: var(--img-width);
  border-radius: 2px;
}
.imagesection .caption {
  font-weight: 300;
  border-radius: 2px;
  padding: 10px;
}
</style>
