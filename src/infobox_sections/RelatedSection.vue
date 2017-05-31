<template>
  <div v-if="nodes.length > 0" class="related_section">
    <titlesubsection v-if="config.title !== undefined" :text="config.title"></titlesubsection>
    <span class="link" v-for="n in nodes"><a :href="get_link(n.data.id)">{{get_label(n)}}</a></span>
  </div>
</template>

<script lang="coffee">
import db from '../database.coffee'
import kgl from './kgl.coffee'
import TitleSubSection from './TitleSubSection.vue'

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
    space: () -> @$store.state.selection.space
  
  watch:
    data: () ->
      @refresh()
  
  methods:
    refresh: () ->
      db.execute {query: @config.query, params: {current: @data.id}}, (data) =>
        result = JSON.parse(data.responseText)
        @nodes = result.data.map (d) => {data: d[0].data, new_data: {label: kgl.parse(@config.label, d[0].data)}}
    get_link: (id) -> if @space? then "#/#{@space.id}/target/#{id}" else "#/target/#{id}"
    get_label: (n) -> if n.new_data.label? then n.new_data.label else n.data.label

  components:
    titlesubsection: TitleSubSection
    
}
</script>

<style scoped>
.related_section {
  padding: 10px 24px 10px 24px;
  font-size: 13px;
  line-height: 19.5px;
}

.link:not(:first-of-type)::before {
  content: ' - ';
}
</style>
