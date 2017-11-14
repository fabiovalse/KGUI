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
        :class="status"
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
        return @get_text()

  methods:
    get_text: () ->
      switch @status
        when 'open' then 'Ora Aperto'
        when 'closed' then 'Ora Chiuso'
        when 'closing_soon' then 'Chiuderà presto'
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
.closing_soon {
  fill: #eadb3f;
}

</style>
