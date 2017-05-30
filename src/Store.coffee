import db from './database.coffee'
import config from './config.coffee'
import Vue from 'vue'

export default {
  state:
    mode: 'fullmap'
    space: undefined
    nodes: undefined
    previews: undefined

    transform: d3.zoomTransform(1)

    target: undefined
    from: undefined
    to: undefined
    path: undefined
    starting_point: undefined

    local_path: '/'
  mutations:
    _set_space: (state, space) ->
      state.space = space
      # FIXME this is a ugly hack
      state.local_path = '/'+([state.space.id].concat(state.local_path.split('/').slice(2))).join('/')
    _set_nodes: (state, nodes) ->
      state.nodes = nodes
    _set_previews: (state, preview) ->
      if not state.previews?
        state.previews = {}

      Vue.set(state.previews, preview.id, preview)
    set_transform: (state, transform) ->
      state.transform = transform
    _set_starting_point: (state, starting_point) ->
      state.starting_point = starting_point
    _reset: (state) ->
      state.mode = 'info'
      state.target = undefined
      state.from = undefined
      state.to = undefined
      state.path = undefined
    _set_target: (state, target) ->
      state.target = target
      state.local_path = (if config.layout.view then "/#{state.space.id}" else '') + "/target/#{target.id}"
    set_from: (state, from) ->
      state.from = from
      state.local_path = (if config.layout.view then "/#{state.space.id}" else '') + "/from/#{if from? then from.id else '_'}/to/#{if state.to? then state.to.id else '_'}"
    set_to: (state, to) ->
      state.to = to
      state.local_path = (if config.layout.view then "/#{state.space.id}" else '') + "/from/#{if state.from? then state.from.id else '_'}/to/#{if to? then to.id else '_'}"
    set_path: (state, path) ->
      state.path = path
    _set_info_state: (state, target) ->
      state.mode = 'info'
      state.target = target
      state.from = undefined
      state.to = undefined
      state.path = undefined
      state.local_path = (if config.layout.view then "/#{state.space.id}" else '') + "/target/#{target.id}"
    _set_directions_state: (state, params) ->
      state.mode = 'directions'
      state.target = undefined
      state.from = params.from
      state.to = params.to
      state.path = params.path
      state.local_path = (if config.layout.view then "/#{state.space.id}" else '') + "/from/#{if params.from? then params.from.id else '_'}/to/#{if params.to? then params.to.id else '_'}"
    fullmap_mode: (state) ->
      state.mode = 'fullmap'
      state.target = undefined
      state.from = undefined
      state.to = undefined
      state.path = undefined
      state.local_path = (if config.layout.view then "/#{state.space.id}" else '') + "/fullmap"

  actions:
    init: (context, params) ->
      if params.default_starting_point?
        db.query_starting_point context, params.default_starting_point

      if params.default_space?
        db.query_nodes context, params.default_space
        db.query_space context, params.default_space

    select: (context, params) ->
      if context.state.mode is 'fullmap'
        context.commit '_reset'

      switch context.state.mode
        when 'info'
          db.query_info context, params.id, '_set_target'
        when 'directions'

          if params.directions_input?
            if params.directions_input is 'from' and context.state.to?
              db.query_directions_dijkstra context, params.id, context.state.to.id
            else if params.directions_input is 'from' and not context.state.to?
              db.query_directions context, params.id
            else if params.directions_input is 'to' and context.state.from?
              db.query_directions_dijkstra context, context.state.from.id, params.id
            else if params.directions_input is 'to' and not context.state.from?
              db.query_directions context, undefined, params.id
          else
            if not context.state.from? and context.state.to?
              db.query_directions_dijkstra context, params.id, context.state.to.id
            else if context.state.from? and not context.state.to?
              db.query_directions_dijkstra context, context.state.from.id, params.id
            else if not context.state.from? and not context.state.to?
              db.query_directions context, params.id

    change_space: (context, id) ->
      db.query_space context, id

    request_previews: (context, id) ->
      db.query_previews context, id

    request_info: (context, id) ->
      db.query_info context, id, '_set_info_state'

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
