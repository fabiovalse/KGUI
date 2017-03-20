<template>
  <div class="related_section">
    <span class="link" v-for="n in nodes"><a :href="'#/target/'+n.id">{{n.label}}</a></span>
  </div>
</template>

<script lang="coffee">
import db from '../database.coffee'
import kgl from './kgl.coffee'

export default {
  props:
    data:
      type: Object
      required: true
    config:
      type: Object
      required: true
  data: () ->
    nodes: []
  mounted: () ->
    @refresh()
  watch:
    data: () ->
      @refresh()
  methods:
    refresh: () ->
      db.execute {query: @config.query, params: {current: @data.id}}, (data) =>
        result = JSON.parse(data.responseText)
        @nodes = result.data.map (d) -> d[0].data
}
</script>

<style scoped>
.related_section {
  padding: 24px;
  font-size: 13px;
  line-height: 19.5px;
  font-family: sans-serif;
}

.link:not(:first-child)::before {
  content: ' - '
}
</style>
