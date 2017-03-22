<template>
  <button class="more" @click="expand_collapse()" :title="get_title()">
    <i :class="get_icon()"></i>
  </button>
</template>

<script lang="coffee">
export default {
  data: () ->
    collapsed: true

  methods: 
    get_icon: () -> if @collapsed then 'icon-chevron-down' else 'icon-chevron-up'

    get_title: () -> if @collapsed then 'Espandi sezione' else 'Collassa sezione'

    expand_collapse: () -> 
      @collapsed = not @collapsed

      @$emit 'expand_collapse', @collapsed
}
</script>

<style scoped>
.more {
  position: absolute;
  bottom: 0;
  right: 5px;
  font-size: 11px;
  cursor: pointer;
  border: none;
  width: 18px;
  padding: 0;
  background: none;
}

</style>
