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

    <div class="footer_notes">
      <div v-for="(note,i) in notes" class="footer_note">
        <sup>{{note_ids[i]}}</sup> <span>{{note}}</span>
      </div>  
    </div>
  </div>
</template>

<script lang="coffee">
import AnnotatedText from './AnnotatedText.vue'

export default {

  computed:
    bilingualtext: () -> JSON.parse(@$store.state.selection.space.bilingualtext)
    notes: () -> @$store.state.selection.space.notes
    note_ids: () -> @$store.state.selection.space.note_ids

  components:
    annotatedtext: AnnotatedText

}
</script>

<style scoped>
  .bilingualtextview {
    padding-top: 80px;
    padding-left: 408px;
    height: 100%;
    overflow-y: scroll;
    background: var(--paper-color);
    box-sizing: border-box;
  }

  table {
    padding: 20px;
  }
  td {
    padding: 10px;
    text-align: justify;
    border-bottom: 1px solid #e6daca;
  }
  tr td:first-child {
    font-size: 20px;
    letter-spacing: 2px;
  }

  .footer_notes {
    padding: 20px;
    font-size: 12px;
    color: rgba(0,0,0,0.54);
  }
  .footer_note {
    padding-bottom: 10px;
  }

  @media (max-width: 480px) {
    .bilingualtextview {
      padding-left: 0px !important;
      padding-top: 48px;
    }
  }
</style>
