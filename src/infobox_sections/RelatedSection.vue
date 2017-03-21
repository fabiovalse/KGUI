<template>
  <div class="related_section">
    <span class="link" v-for="n in nodes"><a :href="get_link(n.id)">{{n.label}}</a></span>
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
  computed:
    space: () -> @$store.state.space
  watch:
    data: () ->
      @refresh()
  methods:
    refresh: () ->
      db.execute {query: @config.query, params: {current: @data.id}}, (data) =>
        result = JSON.parse(data.responseText)
        @nodes = result.data.map (d) -> d[0].data
    get_link: (id) -> if @space? then "#/#{@space.id}/target/#{id}" else "#/target/#{id}"
}
</script>

<style scoped>
.related_section {
  padding: 10px 24px 10px 24px;
  font-size: 13px;
  line-height: 19.5px;
  font-family: sans-serif;
}

.link:not(:first-child)::before {
  content: ' - '
}
</style>
