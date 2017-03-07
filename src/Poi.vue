<template>
  <g
    class="poi"
    :transform="get_translate()"
    @click="select()"
    >
    <g :transform="get_scale()">
      <circle class="background" r="60" cy="5">
        <title>{{data.label}}</title>
      </circle>
      <circle class="foreground" r="60"></circle>
      <foreignObject x="-50" y="-35" width="100" height="100">
        <!--<i class="icon"></i>-->
      </foreignObject>
      <text class="background label hidden" text-anchor="start" dy="0.35em" x="80">
        {{data.label}}
      </text>
      <text class="foreground label hidden" text-anchor="start" dy="0.35em" x="80">
        {{data.label}}
      </text>
    </g>
    <title>{{data.label}}</title>
  </g>
</template>

<script lang="coffee">
export default {
  props: ['data']

  computed:
    target: () -> @$store.state.target
    transform: () -> @$store.state.transform

  methods:
    select: () -> @$store.dispatch 'select', {id: @data.id}
    get_translate: () -> "translate(#{@data.position[0]}, #{@data.position[1]})"
    get_scale: () -> "scale(#{if @transform? then 1/@transform.k else 1})"

}
</script>

<style scoped>
.target text {
  font-weight: bold;
}

.poi {
  cursor: pointer;
}

.poi circle.background {
  fill: #777;
  stroke: #777;
  stroke-width: 3px;
}

.poi circle.foreground {
  fill: #FFF;
  stroke: #DDD;
  stroke-width: 3px;
}

.poi .icon {
  color: #7b5b5b;
  display: block;
  width: 100;
  height: 100;
  font-size: 70;
  text-align: center;
}

.poi .label {
  font-size: 90px;
}
.poi .background.label {
  fill: white;
  stroke: white;
  opacity: 0.2;
  stroke-width: 12;
}
.poi .foreground.label {
  fill: #333;
}

</style>
