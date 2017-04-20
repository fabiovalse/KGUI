<template>
  <div class="bilingualtextview">
    <table cellspacing="0">
      <tr v-for="(row,i) in bilingualtext">
        <th v-if="i === 0">{{bilingualtext[0][0]}}</th>
        <th v-if="i === 0">{{bilingualtext[0][1]}}</th>

        <td v-if="i > 0"><annotatedtext :config="{text: row[0]}" :data="{}"></annotatedtext></td>
        <td v-if="i > 0"><annotatedtext :config="{text: row[1]}" :data="{}"></annotatedtext></td>
      </tr>
    </table>

    <div class="notes">
      <div v-for="(note,i) in notes" class="note">
        <sup>{{note_ids[i]}}</sup> <span>{{note}}</span>
      </div>  
    </div>
  </div>
</template>

<script lang="coffee">
import AnnotatedText from './AnnotatedText.vue'

export default {

  computed:
    bilingualtext: () -> JSON.parse(@$store.state.space.bilingualtext)
    notes: () -> @$store.state.space.notes
    note_ids: () -> @$store.state.space.note_ids

  components:
    annotatedtext: AnnotatedText

}
</script>

<style scoped>
  .bilingualtextview {
    padding-left: 408px;
    height: 100%;
    overflow-y: scroll;
    background: cornsilk;
  }

  table {
    padding: 20px;
  }
  td {
    padding: 10px;
    text-align: justify;
    border-bottom: 1px solid antiquewhite;
  }
  tr td:first-child {
    font-size: 20px;
    letter-spacing: 2px;
  }

  .notes {
    padding: 20px;
    font-size: 12px;
    color: rgba(0,0,0,0.54);
  }
  .note {
    padding-bottom: 10px;
  }

  @media (max-width: 480px) {
    .bilingualtextview {
      padding-left: 0px !important;
      padding-top: 48px;
    }
  }
</style>
