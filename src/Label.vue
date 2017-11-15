<template>
  <g :class="cls">
    <g :transform="cls == 'sublabel' ? 'translate(0,-5)' : ''">
      <text 
        v-if="halo == undefined"
        class="halo"
        :class="status"
        dy="0.35em"
      >{{label}}</text>
      <text
        :class="status != undefined ? status.id : ''"
        dy="0.35em"
      >{{label}}</text>
    </g>
  </g>
</template>

<script lang="coffee">
export default {
  props: ['text', 'halo', 'cls', 'status']
  
  computed:
    label: () ->
      if @text?
        return @text
      else
        return @status.label

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
  fill: #164e08;
}
.closed {
  fill: #b7382e;
}
.closing_soon {
  fill: #754c00;
}

</style>
