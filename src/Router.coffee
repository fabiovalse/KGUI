import App from './App.vue'
import config from './config.coffee'

export default {
  routes: [
    {path: '/', redirect: config.default_local_path}
    {
      name: 'fullmap_mode'
      path: if config.layout.view then '/:space/' else '/'
      component: App
    }
    {
      name: 'target'
      path: if config.layout.view then '/:space/target/:target' else '/target/:target'
      component: App
    }
    {
      name: 'target_only'
      path: if config.layout.infobox then '/target/:target' else '/'
      component: App
    }
    {
      name: 'directions'
      path: if config.layout.view then '/:space/from/:from/to/:to' else '/from/:from/to/:to'
      component: App
    }
  ]
}
