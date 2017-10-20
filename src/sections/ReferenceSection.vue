<template>
  <div class="reference_section">
    <router-link v-for="d in nodes" :to="{name: 'goto_target', params: {target: d._key}}">
      <div class="node" :title="d.label">
        <i :class="'icon-' + icon(d.template)"></i>
      </div>
    </router-link>
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
      cb = (data) =>
        @nodes = data

      db.execute_arango """
      FOR v,e IN 1..2 OUTBOUND @id GRAPH 'CampusMap'
      FILTER e.type == 'in'
      RETURN v
      """, cb, null, {id: @data._id}

    icon: (template) ->
      switch template
        when 'room' then 'placemark'
        when 'institute' then 'building'
        when 'group' then 'group'
        else '' 

}
</script>

<style scoped>
.reference_section {
  display: flex;
  position: absolute;
  top: calc(214px - 40px);
  right: 15px;
  border-bottom: none !important;
}

.node {
  width: 30px;
  height: 30px;
  background: #FFF;
  border-radius: 50%;
  margin-right: 5px;
  text-align: center;
  line-height: 35px;
}
</style>
