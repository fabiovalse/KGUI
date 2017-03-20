<script lang="coffee">
import config from '../config.coffee'
import TextSection from './TextSection.vue'
import HeaderSection from './HeaderSection.vue'
import ImageSection from './ImageSection.vue'
import ListSection from './ListSection.vue'
import SeparatorSection from './SeparatorSection.vue'
import ChineseTextSection from './ChineseTextSection.vue'

export default {
  render: (createElement) ->
    children = @template.map (section) => createElement section.t+'section', {props:{data:@target, config:section}}
    return createElement 'div', {class: {sections: true}}, children
  computed:
    target: () -> @$store.state.target
    template: () -> if config.templates? and @target.template? and config.templates[@target.template]? then config.templates[@target.template] else []
  components:
    textsection: TextSection
    headersection: HeaderSection
    imagesection: ImageSection
    listsection: ListSection
    separatorsection: SeparatorSection
    chinesetextsection: ChineseTextSection
}
</script>

<style scoped>

.sections {
  display: flex;
  flex-direction: column;
}

@media (max-width: 480px){
  .sections {
    display: flex;
    flex-direction: column;
    overflow: hidden !important;
  }
}

</style>
