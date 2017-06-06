<script lang="coffee">
import config from '../config.coffee'
import TextSection from '../infobox_sections/TextSection.vue'
import ListSection from '../infobox_sections/ListSection.vue'
import SourceSection from '../infobox_sections/SourceSection.vue'
import SeparatorSection from '../infobox_sections/SeparatorSection.vue'
import RelatedSection from '../infobox_sections/RelatedSection.vue'
import TimeSection from '../infobox_sections/TimeSection.vue'

export default {
  render: (createElement) ->
    children = @template.map (section) =>
      createElement section.t+'section', {props:{data:@space, config:section}}
      
    return createElement 'div', {class: {sections: true}}, children
  computed:
    space: () -> @$store.state.selection.space
    template: () -> if config.view_templates? and @space.template? and config.view_templates[@space.template]? then config.view_templates[@space.template] else []
  components:
    textsection: TextSection
    listsection: ListSection
    sourcesection: SourceSection
    separatorsection: SeparatorSection
    relatedsection: RelatedSection
    timesection: TimeSection

}
</script>

<style scoped>

</style>
