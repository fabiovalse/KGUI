import db from '../database.coffee'
import config from '../config.coffee'
import Vue from 'vue'

export default {
  state:    
    nodes: undefined
    previews: undefined

    transform: d3.zoomTransform(1)
    path: undefined
    starting_point: undefined
    
  mutations:
    _set_nodes: (state, nodes) ->
      state.nodes = nodes
    _set_previews: (state, preview) ->
      if not state.previews?
        state.previews = {}

      Vue.set(state.previews, preview.id, preview)
    _set_starting_point: (state, starting_point) ->
      state.starting_point = starting_point
    set_transform: (state, transform) ->
      state.transform = transform
    set_path: (state, path) ->
      state.path = path

  actions:
    init: (context, params) ->
      if params.default_starting_point?
        db.query_starting_point context, params.default_starting_point

      if params.default_space?
        #db.query_nodes context, params.default_space # Could be useless
        db.query_space context, params.default_space, '_set_space'

    request_previews: (context, id) ->
      db.query_space context, id, '_set_previews'

    request_directions: (context, conf) ->
      if conf.def
        from_id = context.state.starting_point.id
        to_id = if context.state.target? then context.state.target.id else undefined
      else
        from_id = if conf.from_id? then conf.from_id else undefined
        to_id = if conf.to_id? then conf.to_id else undefined

      # The shortest path between two nodes is computed only when both IDs exist
      if from_id? and to_id?
        db.query_directions_dijkstra context, from_id, to_id
      else
        db.query_directions context, from_id, to_id

}