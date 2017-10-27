import Vue from 'vue'
import App from './App.vue'
import Router from './Router.coffee'
import Store from './store/Store.coffee'
import {global_config, global_class_declaration} from './config.coffee'
import _ from 'lodash'

import Vuex from 'vuex'
Vue.use(Vuex)

import VueRouter from 'vue-router'
Vue.use(VueRouter)

import VueTouch from 'vue-touch'
Vue.use(VueTouch)

router = new VueRouter(Router)
window.store = new Vuex.Store(Store)

# Starts the interval for the Now store variable
window.store.dispatch 'start'

custumizer = (a, b) -> if (_.isArray(a)) then b else undefined

Vue.mixin({
  methods: 
    load_config: (component_config, datum_config, datum_classes, component_class_declaration) ->
      datum_config = JSON.parse datum_config

      class_declaration = _.mergeWith(component_class_declaration, global_class_declaration, custumizer)

      # Cascading merging of different configurations. Priority:
      # datum
      # classes
      # global
      # component
      conf = _.mergeWith(component_config, global_config, custumizer)
      if datum_classes?
        for c in datum_classes
          conf = _.mergeWith(conf, class_declaration[c], custumizer)
      
      conf = _.mergeWith(conf, datum_config, custumizer)

      return conf
})

app = new Vue
  el: '#app'
  template: '''
    <app></app>
  '''
  store: store 
  router: router
  components:
    'app': App
