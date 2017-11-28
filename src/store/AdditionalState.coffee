import db from '../database.coffee'
import config from '../config.coffee'
import Vue from 'vue'

export default {
  state:    
    nodes: undefined
    previews: undefined
    events: []

    transform: d3.zoomTransform(1)
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

  actions:
    init: (context, params) ->
      if params.default_starting_point?
        db.query_starting_point context, params.default_starting_point, (starting_point) ->
          context.commit '_set_starting_point', starting_point[0]
      
      # FIXME horrible hack
      update_events = () ->
        db.query_events (data) ->
          if context.rootState.selection.space?
            context.rootState.additional.events = data.filter (d) ->
              d.day is "#{context.rootState.time.now.getFullYear()}-#{context.rootState.time.now.getMonth()+1}-#{context.rootState.time.now.getDate()}"

            context.rootState.selection.space.nodes.forEach (n) ->
              data.forEach (d) ->
                if d.room == n._key
                  if not n.events?
                    n.events = []
                  n.events.push d
      setInterval update_events, 1000 * 60
      setTimeout update_events, 1000 * 3
      
      # FIXME horrible hack
      update_presences = () ->
        db.query_presences (data) ->
          if context.rootState.selection.space?
            context.rootState.selection.space.nodes.forEach (n) ->
              data.forEach (d) ->
                if d.room == n._key
                  n.presence = d.presence
      setInterval update_presences, 1000 * 60
      setTimeout update_presences, 1000 * 3

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