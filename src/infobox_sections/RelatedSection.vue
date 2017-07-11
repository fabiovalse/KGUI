<template>
  <div v-if="nodes.length > 0" class="related_section">
    <titlesubsection v-if="config.title !== undefined" :text="config.title"></titlesubsection>
    <div class="links">
      <div class="link" v-for="n in nodes">
        <router-link :to="{name: 'goto_space', params: {space: n.data.id}}">
          <div v-if="n.data.icon !== undefined" class="icon">
            <i :class="'icon-' + n.data.icon"></i>
          </div>
          <div v-else class="img" :style="{background: 'url('+global_config.main_uri+'/images/depictions/'+n.data.id+'.jpg) #DDD'}">
          </div>
          <div>{{get_label(n)}}</div>
        </router-link>
      </div>
    </div>
  </div>
</template>

<script lang="coffee">
import db from '../database.coffee'
import global_config from '../config.coffee'
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
    global_config: () -> global_config
  
  watch:
    data: () ->
      @refresh()
  
  methods:
    refresh: () ->
      db.execute {query: @config.query, params: {current: @data.id}}, (data) =>
        result = JSON.parse(data.responseText)
        @nodes = result.data.map (d) => {data: d[0].data, new_data: {label: kgl.parse(@config.label, d[0].data)}}
    get_link: (id) -> "#/target/#{id}"
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
  box-sizing: border-box;
}

.links {
  display: flex;
}
.link {
  width: 100px;
  margin-right: 30px;
}
.link a {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.icon {
  width: 80px;
  height: 80px;
  border-radius: 40px;
  text-align: center;
  font-size: 40px;
  line-height: 90px;
  background: #DDD;
  color: #FAFAFA;
}

.img {
  width: 80px;
  height: 80px;
  border-radius: 40px;
  background-position-x: center !important;
  background-size: cover !important;
  background-repeat: no-repeat !important;
}
</style>
