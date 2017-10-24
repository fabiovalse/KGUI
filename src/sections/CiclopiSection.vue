<template>
  <div class="ciclopi_section" v-if="data._key == 'ciclopi@area.cnr.it'">
    <titlesubsection :text="config.title"></titlesubsection>
    <div class="row" v-if="free_bikes.length > 0">
      <div class="label">{{free_bikes.length}} Pieni</div>
      <div class="bike_places">
        <div class="bike_place free" v-for="d in free_bikes">
          <i v-if="d == 1" class="icon-bicycle"></i>
        </div>
      </div>
    </div>
    <div class="row" v-if="empty_slots.length > 0">
      <div class="label">{{empty_slots.length}} Vuoti</div>
      <div class="bike_places">
        <div class="bike_place empty" v-for="d in empty_slots">
          <i v-if="d == 1" class="icon-bicycle"></i>
        </div>
      </div>
    </div>
    <div class="row" v-if="unavailable_slots.length > 0">
      <div class="label">{{unavailable_slots.length}} Guasti</div>
      <div class="bike_places">
        <div class="bike_place unavailable" v-for="d in unavailable_slots">
          <i v-if="d == 1" class="icon-bicycle"></i>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="coffee">
import kgl from './kgl.coffee'
import TitleSubSection from './TitleSubSection.vue'

export default {
  props:
    data:
      type: Object
      required: true
    config:
      type: Object
      required: true

  data: () ->
    free_bikes: []
    empty_slots: []
    unavailable_slots: []

  mounted: () ->
    _this = @
    fetch('http://campusmap:8529/_db/campusmap/_api/simple/all', {
      method: "PUT"
      body: JSON.stringify({"collection": "CicloPI"})
      headers: {Authorization: "Basic cm9vdDpjMjVhMjAxNw=="}
    })
    .then (response) -> response.json()
    .then (data) ->
      data = data.result[0]
      _this.free_bikes = Array.from(Array(data.free_bikes).keys()).map (d) -> 1
      _this.empty_slots = Array.from(Array(data.empty_slots).keys()).map (d) -> 0
      _this.unavailable_slots = Array.from(Array(data.unavailable_slots).keys()).map (d) -> 2

  components:
    titlesubsection: TitleSubSection
}
</script>

<style scoped>
.ciclopi_section {
  padding: 10px 24px 10px 24px;
}

.row {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
  align-items: center;
  margin-bottom: 10px;
}
.row .label {
  width: 50px;
  margin-right: 10px;
  font-size: 13px;
  text-align: right;
}
.row .bike_places {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
  flex-grow: 1;
}
.row .bike_places .bike_place {
  width: 22px;
  height: 30px;
  margin-right: 2px;
  text-align: center;
  line-height: 33px;
}
.row .bike_places .bike_place.free {
  background: #ccebc5;
}
.row .bike_places .bike_place.empty {
  background: #f2f2f2;
}
.row .bike_places .bike_place.unavailable {
  background: #fbb4ae;
}

</style>