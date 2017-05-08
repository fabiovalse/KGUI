<template>
  <div v-if="text !== undefined" class="bilingualtext_section">
    <div v-for="(t, i) in text" class="field">
      <div class="language" v-html="t.label"></div>
      <div v-html="t.text" :class="{large: isLarge(i)}"></div>
    </div>
    
    <div v-if="notes !== undefined && notes.length > 0" class="footer_notes">
      <div v-for="note in notes" class="footer_note">
        <sup>{{note.label}}</sup> <span>{{note.text}}</span>
      </div>  
    </div>
  </div>
</template>

<script lang="coffee">
import kgl from './kgl.coffee'

export default {
  props:
    data:
      type: Object
      required: true
    config:
      type: Object
      required: true

  methods:
    isLarge: (i) -> i is 0

  computed:
    text: () -> JSON.parse(kgl.parse(@config.text, @data, true))
    notes: () -> if @config.notes? then JSON.parse(kgl.parse(@config.notes, @data)) else undefined

}
</script>

<style scoped>
.bilingualtext_section {
  display: flex;
  flex-direction: column;
  padding: 24px;
}

.large {
  font-size: 30px !important;
}

.field {
  margin-bottom: 15px;
}

.language, .footer_notes {
  font-size: 12px;
  color: rgba(0,0,0,0.54);
}
.footer_notes {
  padding-top: 15px;
  border-top: 1px solid #BBB;
}
.footer_note {
  padding-bottom: 10px;
}
</style>
