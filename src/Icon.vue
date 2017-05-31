<template>
  <g
    v-if="semantic_zoom()"
    :transform="get_translate()"
  >
    <foreignObject :x="get_x()" :y="get_y()" width="100" height="100">
      <i :class="'icon icon-' + data.icon"></i>
    </foreignObject>
  </g>
</template>

<script lang="coffee">
export default {
  props: ['data']

  computed:
    transform: () -> @$store.state.additional.transform

  methods:
    get_translate: () -> "translate(#{@data.position[0]}, #{@data.position[1]})"
    semantic_zoom: () -> @transform.k > 2
    get_x: () ->
      switch @data.icon
        when 'stairs' then -15
        when 'elevator' then -10
        when 'toilet' then -15
    get_y: () ->
      switch @data.icon
        when 'stairs' then -15
        when 'elevator' then -10
        when 'toilet' then -15
}
</script>

<style scoped>
.icon {
  color: #FFF;
}
.icon-stairs {
  font-size: 30px;
}
.icon-elevator {
  font-size: 20px;
}
.icon-toilet {
  font-size: 30px;
}

</style>
