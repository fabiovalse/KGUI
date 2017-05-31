import Vue from 'vue'
import App from './App.vue'
import Router from './Router.coffee'
import Store from './store/Store.coffee'

import Vuex from 'vuex'
Vue.use(Vuex)

import VueRouter from 'vue-router'
Vue.use(VueRouter)

import VueTouch from 'vue-touch'
Vue.use(VueTouch)

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
