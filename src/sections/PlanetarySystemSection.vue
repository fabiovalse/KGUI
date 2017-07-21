<template>
  <svg class="planetarysystemsection">
    <g v-if="celestial_bodies !== undefined" :transform="'translate(0,' + height/2 + ')'">
      <circle
        :class="{sun: primary == 'solar_system|Sun'}"
        :style="'fill: ' + (color !== undefined ? color(celestial_bodies.data.subtype) : '')"
        :r="radius !== undefined ? radius(celestial_bodies.data.equatorial_radius_km) : 0"
      ></circle>

      <g class="orbit" v-for="c in celestial_bodies.children">
        <circle
          :r="distance(c.data.distance_from_primary_km)"
        ></circle>
      </g>
      <g  v-for="(c,i) in celestial_bodies.children"
          class="celestial_body"
          :class="{hover: hover === c}"
          :transform="get_transform(c,i)"
          >
        <g  class="active"
            @click="select(c.data.id)"
            @mouseover="hover = c"
            @mouseout="hover = undefined">
          <circle
            class="halo"
            :r="radius(c.data.equatorial_radius_km)+3"
          ></circle>
          <circle
            class="foreground"
            :style="'fill: ' + color(c.data.subtype)"
            :r="radius(c.data.equatorial_radius_km)"
          ></circle>
        </g>
        
        <g class="suborbit" v-for="so in c.children">
          <circle
            :r="radius(so.data.distance_from_primary_km)"
          ></circle>
        </g>
        <g v-for="(sc,j) in c.children"
            class="subcelestial_body"
            :class="{hover: hover === sc}"
            @click="select(sc.data.id)"
            @mouseover="hover = sc"
            @mouseout="hover = undefined">
          <circle
            class="halo"
            :r="radius(sc.data.equatorial_radius_km)+1"
            :cx="get_cx(sc,j)"
            :cy="get_cy(sc,j)"
          ></circle>
          <circle
            class="foreground"
            :style="'fill: ' + color(sc.data.type)"
            :r="radius(sc.data.equatorial_radius_km)"
            :cx="get_cx(sc,j)"
            :cy="get_cy(sc,j)"
          ></circle>
           <text
            :style="'text-anchor: ' + get_text_anchor(sc,j)"
            :x="get_x(sc,j)"
            :y="get_y(sc,j)"
          >{{sc.id}}</text> 
        </g>

        <text
          class="celestial_body_label"
          :class="{hover: hover === c}"
          :y="-radius(c.data.equatorial_radius_km) - 5"
          @click="select(c.data.id)"
          @mouseover="hover = c"
          @mouseout="hover = undefined"
        >{{c.id}}</text>
      </g> 
    </g>
  </svg>
</template>

<script lang="coffee">
import db from '../database.coffee'

export default {

data: () ->
  celestial_bodies: undefined
  primary_radius: 30
  primary: undefined

  height: 500
  width: undefined
  margin: 10
  
  radius: undefined
  color: undefined

  angles: [60,30,0,-30,-45,20,-10,11,0,-11,0,11,0]
  celestial_body_types: [
    {label: '', value: 'NULL', color: '#ffc252'},
    {label: 'Terrestrial', value: 'terrestrial', color: '#bca87d'},
    {label: 'Gas giant', value: 'gas_giant', color: '#b7b7b7'},
    {label: 'Ice giant', value: 'ice_giant', color: '#7eadd4'},
    {label: 'Asteroid', value: 'asteroid', color: '#e18179'},
    {label: 'Plutoid', value: 'plutoid', color: '#b283c2'},
    {label: 'Satellite', value: 'satellite', color: '#f1a720'}
  ]

  hover: undefined

computed:
  space: () -> @$store.state.selection.space

mounted: () ->
  
  @color = d3.scaleOrdinal()
    .domain @celestial_body_types.map (d) -> d.value
    .range @celestial_body_types.map (d) -> d.color

  @width = @$el.getBoundingClientRect().width

  if @space.config?
    @config = @load_config undefined, @space.config, undefined, undefined
  
  @primary = if @config? and @config.primary? then @config.primary else @space.id

  db.query_children @primary, 'revolves_around', true, (data) => 
    @celestial_bodies = (d3.stratify()
      .id (d) -> d.label
      .parentId (d) => if d.id is @primary then '' else d.primary)(data)
    
    @celestial_bodies.children = @celestial_bodies.children.sort (a,b) -> a.data.distance_from_primary_km - b.data.distance_from_primary_km
    @celestial_bodies.children.forEach (c) ->
      if c.children?
        c.children = c.children.sort (a,b) -> a.data.distance_from_primary_km - b.data.distance_from_primary_km

    @distance = d3.scalePow()
      .exponent 0.4
      .domain [0, d3.max @celestial_bodies.children, (d) -> +d.data.distance_from_primary_km]
      .range [0, @width-@primary_radius/2-@margin]

    @radius = d3.scalePow()
      .exponent 0.4
      .domain [0, d3.max @celestial_bodies.children, (d) -> +d.data.equatorial_radius_km]
      .range [0, 20]

methods:
  to_radian: (angle) -> return angle*Math.PI/180

  get_transform: (d,i) ->
    distance = @distance(+d.data.distance_from_primary_km)
    x = distance * Math.cos @to_radian(@angles[i])
    y = distance * Math.sin @to_radian(@angles[i])
    return "translate(#{x}, #{y})"
  
  get_cx: (d,i) ->
    r = @radius(d.data.distance_from_primary_km)
    a = Math.cos((i*30+60)*Math.PI/180)
    return r*a
  get_cy: (d,i) ->
    r = @radius(d.data.distance_from_primary_km)
    a = Math.sin((i*30+60)*Math.PI/180)
    return r*a

  get_text_anchor: (d,i) ->
    r = @radius(d.data.distance_from_primary_km)
    a = Math.cos((i*30+60)*Math.PI/180)
    return if r*a < 0 then 'end' else 'start'
  get_x: (d,i) ->
    r = @radius(d.data.distance_from_primary_km)
    a = Math.cos((i*30+60)*Math.PI/180)
    return r*a
  get_y: (d,i) ->
    r = @radius(d.data.distance_from_primary_km)
    a = Math.sin((i*30+60)*Math.PI/180)
    return r*a+15

  select: (id) -> @$store.commit 'goto_space', id

}
</script>

<style scoped>
:root {
  --background-color: floralwhite;
}

.planetarysystemsection {
  height: 500px;
  background: floralwhite;
}

.sun {
  fill: #ffc252;
  stroke: #ffe27a;
  stroke-width: 5px; 
}

.celestial_body {
  cursor: pointer;
}
.celestial_body .halo {
  fill: floralwhite;
}
.celestial_body text {
  text-anchor: middle;
}

.subcelestial_body text {
  font-size: 11px;
  fill: #606060;
}

/* hover */
.celestial_body > .active > .foreground, .subcelestial_body > .foreground {
  opacity: 0.5;
}
.hover.celestial_body_label, .hover.subcelestial_body text {
  font-weight: bold;
}
.hover.celestial_body > .active > .foreground, .hover.subcelestial_body > .foreground {
  opacity: 1;
}

.suborbit circle, .orbit circle {
  fill: none;
  stroke: rgba(0,0,0,0.2);
  stroke-width: 1;
}

</style>
