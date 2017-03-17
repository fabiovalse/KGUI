<template>
  <div class="bilingualtextview">
    <table cellspacing="0">
      <tr v-for="row in parse()">
        <td><annotatedtext :config="{text: row[0]}" :data="{}"></annotatedtext></td>
        <td><annotatedtext :config="{text: row[1]}" :data="{}"></annotatedtext></td>
      </tr>
    </table>
  </div>
</template>

<script lang="coffee">
import AnnotatedText from './AnnotatedText.vue'

export default {

  computed:
    space: () -> @$store.state.space

  methods:
    parse: () -> JSON.parse(@space.bilingualtext)

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

  @media (max-width: 480px) {
    .bilingualtextview {
      padding-left: 0px !important;
      padding-top: 48px;
    }
  }
</style>
