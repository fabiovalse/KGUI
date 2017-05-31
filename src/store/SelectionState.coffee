import db from '../database.coffee'
import config from '../config.coffee'

export default {
  state:
    space: undefined
    target: undefined
    from: undefined
    to: undefined

  mutations:
    _set_space: (state, space) ->
      state.space = space
      # FIXME this is a ugly hack
      state.local_path = '/'+([state.space.id].concat(state.local_path.split('/').slice(2))).join('/') 
    _set_target: (state, target) ->
      state.target = target
      state.local_path = (if config.layout.view then "/#{state.space.id}" else '') + "/target/#{target.id}"
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

    set_from: (state, from) ->
      state.from = from
      state.local_path = (if config.layout.view then "/#{state.space.id}" else '') + "/from/#{if from? then from.id else '_'}/to/#{if state.to? then state.to.id else '_'}"
    set_to: (state, to) ->
      state.to = to
      state.local_path = (if config.layout.view then "/#{state.space.id}" else '') + "/from/#{if state.from? then state.from.id else '_'}/to/#{if to? then to.id else '_'}"



  actions:
    change_space: (context, id) ->
      db.query_space context, id, '_set_space'
    request_info: (context, id) ->
      db.query_info context, id, '_set_info_state'
    select: (context, params) ->
      if context.state.mode is undefined
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

}