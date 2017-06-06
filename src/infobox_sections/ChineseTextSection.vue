<template>
  <div class="chinesetext_section">
    
    <div class="character"> 
      <div class="image">
        <img v-if="target.template === 'radical'" :src="config.main_uri+'/images/chinese_radicals_animations/'+target.number+'.gif'">
        <div v-else class="character">{{target.label}}</div>
      </div>
      <div v-if="target.radical !== undefined" class="text">
        <div class="secondary_label" @click="select(target.radical)">{{target.radical}}</div>
        <div class="field_description">radical</div>
      </div>
    </div>

    <div v-if="target.number !== undefined" class="number">
      <div>{{target.number}}</div>
      <div class="field_description">radical<br>number</div>
    </div>

    <div v-if="target.strokecount !== undefined" class="strokecount">
      <div>{{target.strokecount}}</div>
      <div class="field_description">stroke<br>count</div>
    </div>
    
    <div class="sub_info">
      <div v-if="target.variants !== undefined && target.variants !== ''" class="variants">
        <div class="characters">
          <div v-for="variant in target.variants" class="variant">{{variant}}</div>
        </div>
        <div class="field_description"><span class="square">v</span>ariants</div>
      </div>

      <div v-if="target.pinyin !== undefined" class="pinyin">
        <div>{{pinyin}}</div>
        <div class="field_description">pinyin</div>
      </div>

      <div v-if="target.simplified !== undefined && target.simplified !== ''" class="simplified">
        <div class="text">{{target.simplified}}</div>
        <div class="field_description"><span class="square">s</span>implified form</div>
      </div>
    </div>

    <div v-if="target.zhuyin_fuhao !== undefined">
      <div>{{target.zhuyin_fuhao}}</div>
      <div class="field_description">zhuyin fuhao</div>
    </div>
  </div>
</template>

<script lang="coffee">
import PinyinConverter from '../../lib/pinyin_converter.js'
import config from '../config.coffee'

export default {

  computed:
    config: () -> config
    target: () -> @$store.state.selection.target
    pinyin: () -> if @target.pinyin and @target.tone then PinyinConverter.convert("#{@target.pinyin}#{@target.tone}") else @target.pinyin

  methods:
    select: (id) -> @$store.dispatch 'select', {id: 'totusmundus_radicals|'+id}

}
</script>

<style scoped>
.chinesetext_section {
  position: relative;
  display: flex;
  flex-direction: column;
  padding: 16px 24px 20px 24px;
}

.character {
  display: flex;
  flex-direction: row;
  align-items: flex-end;
  justify-content: center;
}
.character .image img {
  width: 150px;
  height: 150px;
}

.number {
  position: absolute;
  top: 16px;
  left: 24px;
  text-align: center;
}
.strokecount {
  position: absolute;
  top: 16px;
  right: 24px; 
  text-align: center;
}

.sub_info {
  display: flex;
  flex-direction: row;
  align-items: flex-end;
  justify-content: center;
}
.variants {
  flex-grow: 1;
  text-align: center;
  font-size: 30px;
}
.variants .characters {
  display: flex;
  flex-direction: row;
  justify-content: center;
}
.variants .square {
  background: #fe7d5b;
}
.variant {
  margin: 0px 5px 0px 5px;
}
.simplified {
  flex-grow: 1;
  text-align: center;
}
.simplified .text {
  font-size: 30px;
}
.simplified .square {
  background: #FEB75B;
}
.pinyin {
  flex-grow: 1;
  text-align: center;
}

.square {
  padding: 1px 4px 1px 5px;
  text-align: center;
  font-weight: bold;
}

.field_description {
  font-size: 12px;
  color: rgba(0,0,0,0.54);
}

</style>
