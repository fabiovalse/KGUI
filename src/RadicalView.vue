<template>
  <div class="radicalview">
    <spaceheader></spaceheader>
    <div v-for="node in nodes" class="radical" @click="select(node.id)" :style="{background: node.strokecount%2 === 0 ? '#ECD9C8' : '#CCB49C'}">
      <div class="number" title="Radical identification number">{{node.number}}</div>
      <div class="strokecount" title="Stroke count">{{node.strokecount}}</div>
      <div class="character">{{node.label}}</div>
      <div class="pinyin" title="Pinyin transliteration">{{node.pinyin}}</div>
      <div class="translation" title="English translation">{{node.translation_en}}</div>
      <div v-if="node.variants !== undefined && node.variants !== ''" class="variants" title="Has variants">v</div>
      <div v-if="node.simplified !== undefined && node.simplified !== ''" class="simplified" title="Has simplified form">s</div>
    </div>
  </div>
</template>

<script lang="coffee">
import SpaceHeader from './SpaceHeader.vue'

export default {
  computed:
    nodes: () -> @$store.state.selection.space.nodes.sort (a,b) -> a.number - b.number

  methods:
    select: (id) -> @$store.commit 'goto_target', id
  
  components:
    spaceheader: SpaceHeader
}
</script>

<style scoped>
  .radicalview {
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
    height: 100%;
    overflow-y: scroll;
    padding-top: 60px;
    padding-left: 430px;
    background: rgb(255, 247, 240);
    box-sizing: border-box;
  }

  .radical {
    position: relative;
    width: 100px;
    height: 100px;
    margin: 5px;
    cursor: pointer;
  }
  .radical:hover {
    background: #ECD9C8 !important;
  }

  .number {
    position: absolute;
    top: 0;
    left: 0;
    color: #FFF;
    background: #303030;
    width: 20px;
    height: 20px;
    text-align: center;
    font-size: 11px;
    line-height: 20px;
  }
  .strokecount {
    position: absolute;
    top: 2px;
    right: 2px;
    color: #303030;
    font-size: 10px;
  }
  .character, .pinyin, .translation {
    width: 100%;
    text-align: center;
  }
  .character {
    font-size: 40px;
    color: #303030;
  }
  .pinyin, .translation {
    font-size: 12px;
    color: #505050;
    padding: 2px 0px 2px 0px;
  }
  .variants {
    position: absolute;
    bottom: 0;
    left: 0;
    background: #fe7d5b;
    color: #303030;
  }
  .simplified {
    position: absolute;
    bottom: 0;
    right: 0;
    background: #FEB75B;
    color: #303030;
  }
  .variants, .simplified {
    width: 15px;
    height: 15px;
    text-align: center;
    font-size: 11px;
    line-height: 15px;
    font-weight: bold;
  }
</style>
