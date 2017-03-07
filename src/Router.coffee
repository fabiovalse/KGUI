import App from './App.vue'
import config from './config.coffee'

export default {
  routes: [
    {name: 'fullmap_mode', path: '/fullmap', component: App}
    {path: '/', redirect: config.default_local_path}
    {name: 'target', path: '/target/:target', component: App}
    {name: 'directions', path: '/from/:from/to/:to', component: App}
  ]
}
