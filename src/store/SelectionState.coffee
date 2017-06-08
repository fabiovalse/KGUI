import db from '../database.coffee'

export default {
  state:
    space_id: undefined
    target_id: undefined
    space: undefined
  mutations:
    goto_space: (state, id) ->
      state.space_id = id
      state.target_id = undefined
    goto_space_target: (state, ids) ->
      state.space_id = ids.space
      state.target_id = ids.target
    goto_target: (state, id) ->
      state.target_id = id

    _set_space: (state, data) ->
      state.space = data
  actions:
    load_space: (context, id) ->
      db.query_space id, (space) -> context.commit '_set_space', space
      # TODO inserire qui la chiamata a query nodes ??
}