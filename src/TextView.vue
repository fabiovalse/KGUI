<template>
  <div class="textview">
    <div>
      <div v-for="(poi,i) in pois">
        <div>{{poi.label}}</div>
        <div>{{poi.description}}</div>
        <div>aaaaaaaaaaaaaaaaaaa</div>
        <div>aaaaaaaaaaaaaaaaaaa</div>
        <div>aaaaaaaaaaaaaaaaaaa</div>
        <div>aaaaaaaaaaaaaaaaaaa</div>
        <div>aaaaaaaaaaaaaaaaaaa</div>
        <div>aaaaaaaaaaaaaaaaaaa</div>
        <div>aaaaaaaaaaaaaaaaaaa</div>
        <div>aaaaaaaaaaaaaaaaaaa</div>
        <div>aaaaaaaaaaaaaaaaaaa</div>
        <div>aaaaaaaaaaaaaaaaaaa</div>
        <div>aaaaaaaaaaaaaaaaaaa</div>
        <div>aaaaaaaaaaaaaaaaaaa</div>
        <div>aaaaaaaaaaaaaaaaaaa</div>
        <div>aaaaaaaaaaaaaaaaaaa</div>
        <div>aaaaaaaaaaaaaaaaaaa</div>
        <div>aaaaaaaaaaaaaaaaaaa</div>
        <div>aaaaaaaaaaaaaaaaaaa</div>
        <div>aaaaaaaaaaaaaaaaaaa</div>
        <div>aaaaaaaaaaaaaaaaaaa</div>
        <div>aaaaaaaaaaaaaaaaaaa</div>
        <div>aaaaaaaaaaaaaaaaaaa</div>
        <div>aaaaaaaaaaaaaaaaaaa</div>
        <div>aaaaaaaaaaaaaaaaaaa</div>
        <div>aaaaaaaaaaaaaaaaaaa</div>
      </div>
    </div>
  </div>
</template>

<script lang="coffee">
export default {
  computed:
    pois: () -> if @$store.state.nodes? then @$store.state.nodes else []
}
</script>

<style scoped>
</style>
