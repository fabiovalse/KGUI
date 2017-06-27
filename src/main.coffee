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

Vue.mixin({
  methods: 
    load_config: (component_config, datum_config, component_class_declaration) ->
      datum_config = JSON.parse datum_config

      class_declaration = _.merge(component_class_declaration, global_class_declaration)

      # Cascading merging of different configurations
      # 'datum_config' has priority over 'global_config' that in turn has priority over the 'component_config'
      conf = _.merge(component_config, global_config, datum_config)

      if conf.classes?
        for c in conf.classes
          conf = _.merge(conf, class_declaration[c])

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
