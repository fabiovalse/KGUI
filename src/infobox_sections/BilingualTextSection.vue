<template>
  <div v-if="text !== undefined" class="bilingualtext_section">
    <div>
      <div class="language">{{text_description[0]}}</div>
      <div class="large">{{text[0]}}</div>
    </div>
    <br>
    <div>
      <div class="language" v-html="text_description[1]"></div>
      <div v-html="text[1]"></div>
      
      <div class="notes">
        <div v-for="(note,i) in notes" class="note">
          <sup>{{note_ids[i]}}</sup> <span>{{note}}</span>
        </div>  
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

  computed:
    text: () -> kgl.parse(@config.text, @data, true)
    text_description: () -> kgl.parse(@config.text_description, @data, true)
    notes: () -> kgl.parse(@config.notes, @data)
    note_ids: () -> kgl.parse(@config.note_ids, @data)

}
</script>

<style scoped>
.bilingualtext_section {
  display: flex;
  flex-direction: column;
  padding: 24px;
}

.large {
  font-size: 30px;
}

.language, .notes {
  font-size: 12px;
  color: rgba(0,0,0,0.54);
}
.notes {
  margin-top: 15px;
  padding-top: 15px;
  border-top: 1px solid #BBB;
}
.note {
  padding-bottom: 10px;
}
</style>
