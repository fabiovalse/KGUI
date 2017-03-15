<template>
  <div class="directionsinfo">
    <div class="expand"><span v-if="mobile_open"><i class="icon-slide-down"></i></span><span v-else><i class="icon-slide-up"></i></span></div>
    <div class="title">
      <b>{{get_minutes(path.weight*10)}} min</b> ({{path.weight*10}} m)
    </div>
    <div class="info" v-for="(node,i) in path.nodes">
      <div class="icon"><i :class="get_info(node, i).icon"></div>
      <div class="text">{{get_info(node, i).text}}</div>
      <div class="partial_distance">{{i < path.links.length-1 ? path.links[i].data.weight*10+'m' : ''}}</div>
    </div>
  </div>
</template>

<script lang="coffee">
export default {

  props: ['mobile_open']

  data: () ->
    human_walking_speed: 1.25

  computed:
    path: () -> @$store.state.path

  methods:
    get_minutes: (distance) ->
      return Math.round((distance) / @human_walking_speed / 60 * 10) / 10

    get_info: (n,i) -> 
      # First step
      if i is 0
        {icon: 'icon-arrow-up', text: 'Prosegui diritto'}
      # Last step
      else if i is @path.nodes.length-1
        {icon: '', text: ''}
      # Intra space steps
      else if n.space.data.id is @path.nodes[i+1].space.data.id
        @angle_to_info @get_angle(@path.nodes[i-1].position, n.position, @path.nodes[i+1].position)
      # Inter space steps
      else if n.space.data.id < @path.nodes[i+1].space.data.id # FIXME: handle stairs and elevators
        {icon: 'icon-stairs', text: 'Sali piano'}
      else if n.space.data.id > @path.nodes[i+1].space.data.id # FIXME: handle stairs and elevators
        {icon: 'icon-stairs', text: 'Scendi piano'}

    angle_to_info: (angle) ->
      if angle > 180
        {icon: 'icon-arrow-right', text: 'Gira a destra'}
      else if angle < 180
        {icon: 'icon-arrow-left', text: 'Gira a sinistra'}
      else
        {icon: 'icon-arrow-up', text: 'Prosegui diritto'}

    get_angle: (p0,p1,p2) ->
      c2 = Math.pow(p0[0] - p2[0], 2) + Math.pow(p0[1] - p2[1], 2)
      a2 = Math.pow(p0[0] - p1[0], 2) + Math.pow(p0[1] - p1[1], 2)
      b2 = Math.pow(p2[0] - p1[0], 2) + Math.pow(p2[1] - p1[1], 2)

      a = Math.sqrt a2
      b = Math.sqrt b2

      val = (a2 + b2 - c2) / (2 * a * b)
      angle = Math.acos(val)

      v1x = p0[0] - p1[0]
      v1y = p0[1] - p1[1]
      v2x = p2[0] - p1[0]
      v2y = p2[1] - p1[1]

      return (Math.atan2(v1x, v1y) - Math.atan2(v2x, v2y)) * 180 / Math.PI

}
</script>

<style scoped>
.directionsinfo {
  padding: 15px;
}

.title {
  font-size: 20px;
  margin-bottom: 20px;
}

.info {
  display: flex;
  margin: 10px;
}
.info .icon {
  width: 60px;
  text-align: left;
}
.info .text {
  flex-grow: 1;
}
.info .partial_distance {
  width: 60px;
  text-align: right;
  color: #BBB;
}

.expand {
  display: none;
  text-align: center;
}

@media (max-width: 480px) {
  .expand {
    display: inline;
  }
}

</style>
