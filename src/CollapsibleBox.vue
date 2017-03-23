<template>
  <div class="collapsiblebox">
    <div class="slot" :class="{collapsed: collapsed}">
      <slot>No content!!</slot>
    </div>
    <div v-if="visible" class="bottom_stripe" :class="{bottom_stripe_collapsed: collapsed}">
      <div class="gradient"></div>
      <div class="button">
        <button class="more" @click="expand_collapse()" :title="get_title()">
          <i :class="get_icon()"></i>
        </button>
      </div>
    </div>
  </div>
</template>

<script lang="coffee">
export default {
  data: () ->
    collapsed: true
    visible: true

  mounted: () ->
    @refresh()

    @observer = new MutationObserver(((mutations) =>
      @refresh()
    ).bind(@))
    
    @observer.observe(
      @$el.querySelector('.slot'),
      { attributes: true, childList: true, characterData: true, subtree: true }
    )

  methods: 
    get_icon: () -> if @collapsed then 'icon-chevron-down' else 'icon-chevron-up'
    get_title: () -> if @collapsed then 'Espandi sezione' else 'Collassa sezione'
    expand_collapse: () -> 
      @collapsed = not @collapsed
    refresh: () ->
      @visible = @$el.querySelector('.slot').clientHeight > 140
}
</script>

<style scoped>
.collapsiblebox {
  position: relative;
}

.slot {
  overflow-y: hidden;
}
.collapsed {
  max-height: 145px;
}

.bottom_stripe {
  width: 100%;
  text-align: center;
}
.bottom_stripe_collapsed {
  position: absolute;
  bottom: 0;
}
.gradient {
  height: 10px;
  background: transparent; /* For browsers that do not support gradients */
  background: -webkit-linear-gradient(transparent, #FFF); /* For Safari 5.1 to 6.0 */
  background: -o-linear-gradient(transparent, #FFF); /* For Opera 11.1 to 12.0 */
  background: -moz-linear-gradient(transparent, #FFF); /* For Firefox 3.6 to 15 */
  background: linear-gradient(transparent, #FFF); /* Standard syntax */
}
.button {
  width: 100%;
  background: #FFF;
}
.more {
  font-size: 11px;
  cursor: pointer;
  border: none;
  width: 100%;
  height: 20px;
  padding: 0;
  background: none;
  outline: none;
}

</style>
