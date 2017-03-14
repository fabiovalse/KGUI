<script lang="coffee">
import config from './config.coffee'
import TextSection from './infobox_sections/TextSection.vue'
import HeaderSection from './infobox_sections/HeaderSection.vue'
import ImageSection from './infobox_sections/ImageSection.vue'

export default {
  render: (createElement) ->
    children = @template.map (section) => createElement section.t+'section', {props:{data:@target, config:section}}
    return createElement 'div', {class: {infobox: true, mobile_open: @mobile_open}, on: {click: @click}}, children
  props:
    searchdirectionsbox_enabled:
      type: Boolean
    mobile_open:
      type: Boolean
  computed:
    mode: () -> @$store.state.mode
    target: () -> @$store.state.target
    template: () -> config.templates[@target.template]
  methods:
    click_directions: () -> @$store.dispatch 'request_directions', {def: true}
    click_node: (d) -> @$store.dispatch 'select', {id: d.id}
    click: () -> @$emit 'mobile_open'
  components:
    textsection: TextSection
    headersection: HeaderSection
    imagesection: ImageSection
}
</script>

<style scoped>
.infobox {
  box-shadow: 0 0 20px rgba(0,0,0,0.3);
}
.profile {
  position: relative;
  display: flex;
  padding: 10px;
  font-size: 13px;
  color: #fff;
  background: #b44646;
  min-height: 68px;
}
.profile .label {
  font-size: 21px;
}
.node {
  cursor: pointer;
}
.mobile_open {
  top: 0%;
  margin-top: 0px;
}
button {
  position: absolute;
  top: -35%;
  right: 20px;

  display: flex;
  justify-content: center;
  width: 60px;
  height: 60px;
  font-size: 20px;

  border-radius: 50%;
  border: none;

  cursor: pointer;
  background: #FFF;
  color: #00B3FD;
  box-shadow: 0 1px 6px 0 rgba(0,0,0,.3);
}
button i {
  height: 20px;
}

.target_info, .directions_info {
  display: flex;
  flex-direction: column;
}
.expand {
  display: none;
  text-align: center;
}

@media (max-width: 480px) {
  .infobox {
    padding-top: 0px;
    z-index: 1;
  }
  .expand {
    display: inline;
  }
  button {
    right: 10px;
    width: 48px;
    height: 48px;
  }
}

</style>
