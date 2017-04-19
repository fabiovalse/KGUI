<template>
  <div v-if="text !== undefined" class="bilingualtext_section">
    <div>
      <div class="large">{{text[0]}}</div>
      <div class="language">{{text_description[0]}}</div>  
    </div>
    <br>
    <div>
      <div>{{text[1]}}</div>
      <div class="language">{{text_description[1]}}</div>
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
    text: () -> kgl.parse(@config.text, @data)
    text_description: () -> kgl.parse(@config.text_description, @data)

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

.language {
  font-size: 12px;
  color: rgba(0,0,0,0.54);
}
</style>
