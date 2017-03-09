import App from './App.vue'
import config from './config.coffee'

export default {
  routes: [
    {name: 'fullmap_mode', path: '/:space/fullmap', component: App}
    {path: '/', redirect: config.default_local_path}
    {name: 'target', path: '/:space/target/:target', component: App}
    {name: 'directions', path: '/:space/from/:from/to/:to', component: App}
  ]
}
