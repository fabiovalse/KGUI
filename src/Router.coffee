import App from './App.vue'
import config from './config.coffee'

export default {
  routes: [
    {path: '/', redirect: config.default_local_path}
    {
      name: 'fullmap_mode'
      path: if config.view then '/:space/fullmap' else '/fullmap'
      component: App
    }
    {
      name: 'target'
      path: if config.view then '/:space/target/:target' else '/target/:target'
      component: App
    }
    {
      name: 'directions'
      path: if config.view then '/:space/from/:from/to/:to' else '/from/:from/to/:to'
      component: App
    }
  ]
}
