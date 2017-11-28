<script lang="coffee">
import config from '../config.coffee'
import TextSection from './TextSection.vue'
import BilingualTextSection from './BilingualTextSection.vue'
import HeaderSection from './HeaderSection.vue'
import ImageSection from './InfoboxImageSection.vue'
import ListSection from './ListSection.vue'
import SeparatorSection from './SeparatorSection.vue'
import ChineseTextSection from './ChineseTextSection.vue'
import RelatedSection from './RelatedSection.vue'
import TimeSection from './TimeSection.vue'
import ActionSection from './ActionSection.vue'
import CollapsibleBox from '../CollapsibleBox.vue'
import SourceSection from './SourceSection.vue'
import TimeTableSection from './TimeTableSection.vue'
import CiclopiSection from './CiclopiSection.vue'
import BusStopSection from './BusStopSection.vue'
import ReferenceSection from './ReferenceSection.vue'
import CalendarSection from './CalendarSection.vue'
import TagSection from './TagSection.vue'
import StatusSection from './StatusSection.vue'

export default {
  render: (createElement) ->
    children = @template.map (section) => 
      if section.collapsible
        createElement 'collapsiblebox', {}, [createElement section.t+'section', {props:{data:@target, config:section}, key: @target._key}]
      else
        createElement section.t+'section', {props:{data:@target, config:section}, key: @target._key}
      
    return createElement 'div', {class: {sections: true}}, children
  computed:
    target: () -> @$store.state.selection.target
    template: () -> if config.templates? and @target.template? and config.templates[@target.template]? then config.templates[@target.template] else []
  components:
    textsection: TextSection
    bilingualtextsection: BilingualTextSection
    headersection: HeaderSection
    imagesection: ImageSection
    listsection: ListSection
    separatorsection: SeparatorSection
    chinesetextsection: ChineseTextSection
    relatedsection: RelatedSection
    timesection: TimeSection
    actionsection: ActionSection
    collapsiblebox: CollapsibleBox
    sourcesection: SourceSection
    timetablesection: TimeTableSection
    ciclopisection: CiclopiSection
    referencesection: ReferenceSection
    calendarsection: CalendarSection
    busstopsection: BusStopSection
    tagsection: TagSection
    statussection: StatusSection

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

  .sections > div:not(.image_section):not(.header_section) {
    order:3;
  }

}

</style>
<style>
.infobox .sections > :not(:last-child):not(.image_section):not(.header_section) {
  border-bottom: 1px solid #DDD;
}
</style>
