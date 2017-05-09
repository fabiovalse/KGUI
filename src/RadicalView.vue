<template>
  <div class="radicalview">
    <div v-for="node in nodes" class="radical" @click="select(node)" :style="{background: node.strokecount%2 === 0 ? '#E0C5AA' : '#CCB49C'}">
      <div class="number" title="Radical identification number">{{node.number}}</div>
      <div class="strokecount" title="Stroke count">{{node.strokecount}}</div>
      <div class="character">{{node.label}}</div>
      <div class="pinyin" title="Pinyin transliteration">{{node.pinyin}}</div>
      <div class="translation" title="English translation">{{node.translation_en}}</div>
    </div>
  </div>
</template>

<script lang="coffee">
export default {
  computed:
    nodes: () -> @$store.state.nodes.sort (a,b) -> a.number - b.number

  methods:
    select: (item) -> @$store.dispatch 'select', {id: item.id}
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
    background: #ECD9C8;
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
</style>
