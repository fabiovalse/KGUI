<template>
  <div v-if="groups.length > 0" class="related_section">
    <titlesubsection v-if="config.title !== undefined" :text="config.title"></titlesubsection>
    <div class="group" v-for="group in groups">
      
      <div class="label">{{group.label}}</div>
      
      <div :class="'links ' + style_type">
        <div class="link" v-for="n in group.nodes">
          <!-- Space Info -->
          <router-link v-if="n.view !== undefined && n.template !== undefined" :to="{name: 'goto_space', params: {space: n._key}}">
            <div v-if="n.icon !== undefined" class="icon">
              <i :class="'icon-' + n.icon"></i>
            </div>
            <div v-else-if="no_image_types.indexOf(style_type) < 0" class="img" :style="{background: 'url('+global_config.main_uri+'/images/depictions/'+n._key+'.jpg) #DDD'}">
            </div>
            <div class="label">{{get_label(n)}}</div>
          </router-link>
          
          <!-- Info -->
          <router-link v-if="n.template !== undefined" :to="{name: 'goto_target', params: {target: n._key}}">
            <div v-if="n.icon !== undefined" class="icon">
              <i :class="'icon-' + n.icon"></i>
            </div>
            <div v-else-if="no_image_types.indexOf(style_type) < 0" class="img" :style="{background: 'url('+global_config.main_uri+'/images/depictions/'+n._key+'.jpg) #DDD'}">
            </div>
            <div class="label">{{get_label(n)}}</div>
          </router-link>
        </div>
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
    groups: []
    no_image_types: ['list']
  
  mounted: () ->
    @refresh()
  
  computed:
    space: () -> @$store.state.selection.space
    global_config: () -> global_config
    style_type: () -> if @config.type? then @config.type else 'big_image'
  
  watch:
    data: () ->
      @refresh()
  
  methods:
    refresh: () ->
      cb = (data) =>
        if @config.aggregator?
          @aggregations = {}

          data.forEach (d) =>
            if @aggregations.hasOwnProperty(d[@config.aggregator])
              @aggregations[d[@config.aggregator]].nodes.push d
            else
              @aggregations[d[@config.aggregator]] = {
                label: if d[@config.aggregator] is '' then 'Altro Personale' else d[@config.aggregator],
                nodes: [d]
              }
          
          @groups = Object.values(@aggregations)
        else if data.length > 0
          @groups = [{label: '', nodes: data}]
        else
          @groups = []

      db.execute_arango @config.query, {id: @data._id}, true, null, cb, null

    get_link: (id) -> "#/target/#{id}"
    get_label: (n) -> n.label # FIXME: if n.new_data.label? then n.new_data.label else n.data.label

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

.group > .label {
  margin: 20px 0px 10px 0px;
  font-size: 14px;
  color: rgba(0,0,0,0.54);
}

.links {
  display: flex;
  flex-wrap: wrap;
}

/* BIG-IMAGE
*/
.links.big_image .link {
  width: 100px;
  margin: 0px 10px 15px 0px;
  text-align: center;
}
.links.big_image .link a {
  display: flex;
  flex-direction: column;
  align-items: center;
}
.links.big_image .icon {
  width: 80px;
  height: 80px;
  border-radius: 40px;
  text-align: center;
  font-size: 40px;
  line-height: 90px;
  background: #DDD;
  color: #FAFAFA;
}
.links.big_image .img {
  width: 80px;
  height: 80px;
  border-radius: 40px;
  background-position-x: center !important;
  background-size: cover !important;
  background-repeat: no-repeat !important;
}

/* SMALL IMAGE
*/
.links.small_image .link {
  width: 50%;
  margin: 0px 0px 15px 0px;
}
.links.small_image .link a {
  display: flex;
  justify-content: center;
}
.links.small_image .icon {
  width: 40px;
  height: 40px;
  border-radius: 40px;
  text-align: center;
  font-size: 40px;
  line-height: 90px;
  background: #DDD;
  color: #FAFAFA;
}
.links.small_image .img {
  width: 40px;
  height: 40px;
  border-radius: 40px;
  background-position-x: center !important;
  background-size: cover !important;
  background-repeat: no-repeat !important;
}
.links.small_image .label {
  width: 50%;
  margin-left: 10px;
}

/* LIST
*/
.links.list {
  flex-direction: column;
}
.links.list .link {
  margin-bottom: 5px;
}
.links.list .link a {
  
}
.links.list .label {
  margin-left: 10px;
}
</style>
