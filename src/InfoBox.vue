<template>
  <div class="infobox" :class="{mobile_open: mobile_open}" @click="click">
    <div v-if="target !== undefined" class="target_info">
      <div class="expand"><span v-if="mobile_open"><i class="icon-slide-down"></i></span><span v-else><i class="icon-slide-up"></i></span></div>
      
      <div class="profile">
        <button v-if="searchdirectionsbox_enabled && target.position !== undefined" @click.stop="click_directions"><i class="icon-compass"></i></button>
        <div class="img" style="background-image: url(&quot;http://www.iit.cnr.it//sites/default/files/images/people/matteo.abrate.jpg&quot;);"></div>
        <div class="info">
          <div class="label">{{target.label}}</div>
          <div class="position">{{target.description}}</div>
        </div>
      </div>

      <div v-if="target.out.length > 0">
        <div><b>Related nodes</b></div>
        <ul>
          <li
            v-for="d in target.out"
            class="node"
            @click.stop="click_node(d)"
          >{{d.label}}</li>
        </ul>
      </div>
    </div>
    <div v-if="mode === 'directions'" class="directions_info">
      <div class="expand"><span v-if="mobile_open"><i class="icon-slide-down"></i></span><span v-else><i class="icon-slide-up"></i></span></div>
      Direzionati!
    </div>
  </div>
</template>

<script lang="coffee">
export default {
  props:
    searchdirectionsbox_enabled:
      type: Boolean
    mobile_open:
      type: Boolean
  computed:
    mode: () -> @$store.state.mode
    target: () -> @$store.state.target
  methods:
    click_directions: () -> @$store.dispatch 'request_directions', {def: true}
    click_node: (d) -> @$store.dispatch 'select', {id: d.id}
    click: () -> @$emit 'mobile_open'
    
}
</script>

<style scoped>
.infobox {
  box-shadow: 0 0 20px rgba(0,0,0,0.3);
  padding-top: 130px;
}
.profile {
  position: relative;
  display: flex;
  padding: 10px;
  font-size: 13px;
  color: #fff;
  background: #b44646;
  min-height: 68px;
}
.profile .label {
  font-size: 21px;
}
.node {
  cursor: pointer;
}
.mobile_open {
  top: 0%;
  margin-top: 0px;
}
button {
  position: absolute;
  top: -35%;
  right: 20px;

  display: flex;
  justify-content: center;
  width: 60px;
  height: 60px;
  font-size: 20px;
  
  border-radius: 50%;
  border: none;
  
  cursor: pointer;
  background: #FFF;
  color: #b44646;
  box-shadow: 0 1px 6px 0 rgba(0,0,0,.3);
}
button i {
  height: 20px;
}

.target_info, .directions_info {
  display: flex;
  flex-direction: column;
}
.expand {
  display: none;
  text-align: center;
}

@media (max-width: 480px) {
  .infobox {
    padding-top: 0px;
    z-index: 1;
  }
  .expand {
    display: inline;
  }
}

</style>
