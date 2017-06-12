import db from '../database.coffee'

export default {
  state:
    space_id: undefined
    target_id: undefined
    space: undefined
    target: undefined
    
    from_id: undefined
    to_id: undefined
    directions: undefined
  getters:
    mode: (state) ->
      if state.target?
        return 'target'
      else if state.directions?
        return 'directions'
      else
        return 'space'
  mutations:
    goto_space: (state, id) ->
      state.space_id = id
      state.target_id = undefined
      state.from_id = undefined
      state.to_id = undefined
    goto_space_target: (state, ids) ->
      state.space_id = ids.space
      state.target_id = ids.target
      state.from_id = undefined
      state.to_id = undefined
    goto_target: (state, id) ->
      state.target_id = id
      state.from_id = undefined
      state.to_id = undefined
    goto_directions: (state, ids) ->
      state.space_id = ids.space
      state.target_id = undefined
      state.from_id = ids.from
      state.to_id = ids.to
    clear: (state) ->
      state.target_id = undefined
      state.from_id = undefined
      state.to_id = undefined

    unload_target: (state) ->
      state.target = undefined
    unload_directions: (state) ->
      state.directions = undefined

    _set_space: (state, data) ->
      state.space = data
    _set_target: (state, data) ->
      state.target = data
    _set_directions: (state, data) ->
      state.directions = data
  actions:
    load_space: (context, id) ->
      db.query_space id, (space) -> context.commit '_set_space', space
    load_target: (context, id) ->
      db.query_target id, (target) -> context.commit '_set_target', target
    load_directions: (context, ids) ->
      db.query_directions ids, (directions) -> context.commit '_set_directions', directions

    select: (context, params) ->
      if context.getters.mode isnt 'directions'
        # FIXME this should be more smart
        if params.d.view?
          context.commit 'goto_space', params.d.id
        else if params.d.template?
          context.commit 'goto_target', params.d.id
      else
        ids = {space: context.state.space_id, from: context.state.from_id, to: context.state.to_id}

        if params.directions_input?
          ids[params.directions_input] = params.d.id
        else if ids.from is '_'
          ids.from = params.d.id
        else if ids.to is '_'
          ids.to = params.d.id
        # else do nothing

        context.commit 'goto_directions', ids
}