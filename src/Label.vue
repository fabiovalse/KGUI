<template>
  <g :class="cls">
    <g :transform="cls == 'sublabel' ? 'translate(0,-5)' : ''">
      <text 
        v-if="halo == undefined"
        class="halo"
        dy="0.35em"
        :class="{open: open != undefined && open, closed: open != undefined && !open}"
      >{{text}}</text>
      <text
        class="text"
        dy="0.35em"
        :class="{open: open != undefined && open, closed: open != undefined && !open}"
      >{{text}}</text>
    </g>
  </g>
</template>

<script lang="coffee">
export default {
  props: ['text', 'halo', 'cls', 'open']
  
}
</script>

<style scoped>
.halo {
  fill: none;
  stroke: #FFF;
  stroke-width: 2px;
  opacity: 0.4;
}

.sublabel {
  font-size: 12.5px;  
}

.open {
  fill: #238e0a;
}
.closed {
  fill: #b7382e;
}

</style>
