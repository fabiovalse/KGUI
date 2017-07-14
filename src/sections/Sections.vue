<script lang="coffee">
import Vue from 'vue'
import config from '../config.coffee'
import TitleSection from './TitleSection.vue'
import SubtitleSection from './SubtitleSection.vue'
import ImageSection from './ImageSection.vue'
import DescriptionSection from './DescriptionSection.vue'
import MailingSection from './MailingSection.vue'
import PlanetSection from './PlanetSection.vue'
import TextSection from './TextSection.vue'
import ListSection from './ListSection.vue'
import SourceSection from './SourceSection.vue'
import SeparatorSection from './SeparatorSection.vue'
import RelatedSection from './RelatedSection.vue'
import AnnotationSection from './AnnotationSection.vue'
import TimeSection from './TimeSection.vue'
import ZoomableImageView from './zoomable_image/ZoomableImageView.vue'

export default {
  props:
    template_type:
      type: String
      required: true

  render: (createElement) ->
    children = @template.map (section) =>
      createElement section.t+'section', {
        props:
          data: @space
          config: section
        on:
          'open': () =>
            console.log 'open'
            Vue.set section, 'fullscreen', true
      }
      
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
    planetsection: PlanetSection
    annotationsection: AnnotationSection
    zoomableimagesection: ZoomableImageView

}
</script>

<style scoped>

</style>
