<template>
  <div class="textview">
    {{text}}
  </div>
</template>

<script lang="coffee">
export default {
  computed:
    text: () -> if @$store.state.space? then @$store.state.space.text else ''
}
</script>

<style scoped>
.textview {
  height: 100%;
  box-sizing: border-box;
  padding: 12px;
  padding-left: calc(var(--left-panel-width) + 12px);
  overflow-y: scroll;
}
</style>
