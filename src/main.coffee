import Vue from 'vue'
import App from './App.vue'
import Store from './Store.coffee'
import Router from './Router.coffee'

import Vuex from 'vuex'
Vue.use(Vuex)

import VueRouter from 'vue-router'
Vue.use(VueRouter)

router = new VueRouter(Router)
store = new Vuex.Store(Store)

store.watch ((d) -> d.local_path), ((local_path) -> router.push local_path)

app = new Vue
  el: '#app'
  template: '''
    <app></app>
  '''
  store: store 
  router: router
  components:
    'app': App
