export default {
  state:
    now: new Date()
  
  mutations:
    update_time: (state) ->
      state.now = new Date
  
  actions:
    start: (context) ->
      setInterval (() => context.commit('update_time')), 1000 * 60

}