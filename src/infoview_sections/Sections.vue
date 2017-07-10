<script lang="coffee">
import config from '../config.coffee'
import TitleSection from './TitleSection.vue'
import SubtitleSection from './SubtitleSection.vue'
import ImageSection from './ImageSection.vue'
import DescriptionSection from './DescriptionSection.vue'
import MailingSection from './MailingSection.vue'
import TextSection from '../infobox_sections/TextSection.vue'
import ListSection from '../infobox_sections/ListSection.vue'
import SourceSection from '../infobox_sections/SourceSection.vue'
import SeparatorSection from '../infobox_sections/SeparatorSection.vue'
import RelatedSection from '../infobox_sections/RelatedSection.vue'
import TimeSection from '../infobox_sections/TimeSection.vue'

export default {
  props:
    template_type:
      type: String
      required: true

  render: (createElement) ->
    children = @template.map (section) =>
      createElement section.t+'section', {props:{data:@space, config:section}}
      
    return createElement 'div', {class: {sections: true}}, children

  computed:
    space: () -> @$store.state.selection.space
    default_config: () ->
      info: if @space.template? then [@space.template] else [] # FIXME: template should be eventually moved within the config (cson files)
      header: ["title", "subtitle", "description"]
    datum_config: () -> if @space.config? then @space.config else '{}'
    config: () -> @load_config @default_config, @datum_config, undefined, undefined
    template: () ->
      if config.view_templates? and @config[@template_type]?
        return @config[@template_type].map((d) -> config.view_templates[d]).reduce (a,b) -> a.concat(b)
      else
        return []
  
  components:
    textsection: TextSection
    titlesection: TitleSection
    subtitlesection: SubtitleSection
    imagesection: ImageSection
    descriptionsection: DescriptionSection
    mailingsection: MailingSection
    listsection: ListSection
    sourcesection: SourceSection
    separatorsection: SeparatorSection
    relatedsection: RelatedSection
    timesection: TimeSection

}
</script>

<style scoped>

</style>
