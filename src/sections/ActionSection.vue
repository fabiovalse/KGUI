<template>
  <div class="action_section">
    <div v-for="action in actions" class="action">
      <a :href="get_link(action.id)">
        <div class="icon"><i :class="'icon-'+action.icon"></i></div>
        <div class="label">{{action.label.toUpperCase()}}</div>
      </a>
    </div>
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
    actions: () -> 
      @config.actions.map (action) => {
        id: kgl.parse(action.id, @data)
        icon: action.icon
        label: kgl.parse(action.label, @data)
      }
    local_path: () -> @$store.state.selection.local_path

  methods:
    get_link: (id) -> "#/#{id}/#{@local_path.split('/').slice(2).join('/')}" #FIXME: create a class for handling the local path

}
</script>

<style scoped>
.action_section {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 83px;
}

.action {
  width: 100px;
  text-align: center;
  padding: 5px;
}

a:hover {
  text-decoration: none;
}

.icon {
  font-size: 18px;
}
.label {
  font-size: 12px;
  font-weight: bold;
  margin-top: 5px;
}
</style>
