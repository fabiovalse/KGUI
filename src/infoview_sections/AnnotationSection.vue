<template>
  <div v-if="space.nodes.length > 0" class="annotation_section">
    <titlesubsection v-if="config.title !== undefined" :text="config.title"></titlesubsection>
    <div class="links">
      <div class="link" v-for="n in space.nodes">
        <router-link :to="{name: 'goto_space_target', params: {space: space.id, target: n.id}}">
          <div v-if="n.icon !== undefined" class="icon">
            <i :class="'icon-' + n.icon"></i>
          </div>
          <div v-else class="img" :style="{background: 'url('+global_config.main_uri+'/images/depictions/'+n.id+'.jpg) #DDD'}">
          </div>
          <div class="label">{{n.label}}</div>
        </router-link>
      </div>
    </div>
  </div>
</template>

<script lang="coffee">
import db from '../database.coffee'
import global_config from '../config.coffee'
#import kgl from './kgl.coffee'
import TitleSubSection from '../infobox_sections/TitleSubSection.vue'

export default {
  props:
    data:
      type: Object
      required: true
    config:
      type: Object
      required: true
  
  computed:
    space: () -> @$store.state.selection.space
    global_config: () -> global_config

  components:
    titlesubsection: TitleSubSection
    
}
</script>

<style scoped>
.annotation_section {
  padding: 10px 24px 10px 24px;
  font-size: 13px;
  line-height: 19.5px;
  box-sizing: border-box;
}

.links {
  display: flex;
  flex-wrap: wrap;
}
.link {
  width: 45%;
  margin-bottom: 10px;
}
.link a {
  display: flex;
  align-items: center;
}
.link .label {
  overflow: hidden;
  text-overflow: ellipsis;
  width: 87%;
  white-space: nowrap;
}

.icon, .img {
  width: 40px;
  height: 40px;
  border-radius: 20px;
  margin-right: 10px;
}
.icon {
  text-align: center;
  font-size: 25px;
  line-height: 49px;
  background: #DDD;
  color: #FAFAFA;
}
.img {
  background-position-x: center !important;
  background-size: cover !important;
  background-repeat: no-repeat !important;
}
</style>
