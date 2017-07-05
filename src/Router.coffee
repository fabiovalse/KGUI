import App from './App.vue'
import config from './config.coffee'

export default {
  routes: [
    {path: '/', redirect: config.default_local_path}
    {
      name: 'goto_space'
      path: '/:space/'
      component: App
    }
    {
      name: 'goto_space_target'
      path: '/:space/target/:target'
      component: App
    }
    {
      name: 'goto_target'
      path: '/target/:target'
      component: App
    }
    {
      name: 'goto_directions'
      path: '/:space/from/:from/to/:to'
      component: App
    }
  ]
}
