<template>
  <div class="tag_section">
    <div class="tag" v-for="tag in tags">{{tag}}</div>
  </div>
</template>

<script lang="coffee">
import kgl from './kgl.coffee'

export default {
  props:
    data:
      type: Object
      required: true
    config:
      type: Object
      required: true

  computed:
    tags: () -> kgl.parse(@config.tags, @data)

}
</script>

<style scoped>
.tag_section {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
  font-size: 13px;
  text-transform: uppercase;
  padding: 16px;
}
.tag {
  padding: 5px 5px;
  margin: 4px;
  background: var(--main-color);
  color: #FFF;
  border-radius: 2px;
  cursor: pointer;
}
</style>
