import SelectionState from './SelectionState.coffee'
import AdditionalState from './AdditionalState.coffee'

export default {
  state: Object.assign(AdditionalState.state, SelectionState.state)
  mutations: Object.assign(AdditionalState.mutations, SelectionState.mutations)
  actions: Object.assign(AdditionalState.actions, SelectionState.actions)
}
