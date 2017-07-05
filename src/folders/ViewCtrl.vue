<template>
  <div class="viewctrl">
    <button
      :class="{active: value === 'icons'}"
      @click="$emit('input', 'icons')"
      title="Icons view">
        <i class="icon-grid"></i>
    </button>
    <button
      :class="{active: value === 'list'}"
      @click="$emit('input', 'list')"
      title="List view">
        <i class="icon-list"></i>
    </button>
  </div>
</template>

<script lang="coffee">
export default {
  props: ['value']
}
</script>

<style scoped>
.viewctrl {
    text-align: right;
    margin-bottom: 8px;
}
button {
    border: 0;
    background: none;
    width: 48px;
    height: 48px;
    border-radius: 24px;
    font-size: 20px;
    padding-top: 6px;
    color: #777;
    outline: none !important;
}
button.active {
    color: black;
    background: rgba(0,0,0,0.1);
}
</style>