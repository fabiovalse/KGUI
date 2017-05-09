<template>
  <div class="chinesetext_section">
    
    <div class="chinese_text">
      <div>
        <div class="label">
          <table class="grid">
            <tr><td></td><td></td><td></td></tr>
            <tr><td></td><td></td><td></td></tr>
            <tr><td></td><td></td><td></td></tr>
          </table>
          <div class="character">{{target.label}}</div>
        </div>
        <div class="field_description">Chinese</div>
      </div>  
      <div v-if="target.radical !== undefined">
        <div class="secondary_label" @click="select(target.radical)">{{target.radical}}</div>
        <div class="field_description">radical</div>
      </div>
    </div>

    <div v-if="target.variants !== undefined && target.variants !== ''">
      <div class="variants">
        <div v-for="variant in target.variants" class="variant">{{variant}}</div>
      </div>
      <div class="field_description">variants</div>
    </div>
    <div v-if="target.simplified !== undefined && target.simplified !== ''">
      <div>{{target.simplified}}</div>
      <div class="field_description">simplified form</div>
    </div>
    <div v-if="target.pinyin !== undefined">
      <div>{{pinyin}}</div>
      <div class="field_description">pinyin</div>
    </div>
    <div v-if="target.zhuyin_fuhao !== undefined">
      <div>{{target.zhuyin_fuhao}}</div>
      <div class="field_description">zhuyin fuhao</div>
    </div>
  </div>
</template>

<script lang="coffee">
import PinyinConverter from '../../lib/pinyin_converter.js'

export default {

  computed:
    target: () -> @$store.state.target
    pinyin: () -> if @target.pinyin and @target.tone then PinyinConverter.convert("#{@target.pinyin}#{@target.tone}") else @target.pinyin

  methods:
    select: (id) -> @$store.dispatch 'select', {id: 'totusmundus_radicals|'+id}

}
</script>

<style scoped>
.chinesetext_section {
  display: flex;
  flex-direction: column;
  padding: 16px 24px 20px 24px;
}
.chinesetext_section > * {
  padding-bottom: 10px;
}

.chinese_text {
  display: flex;
  flex-direction: row;
  align-items: flex-end;
}
.chinese_text > * {
  margin-right: 20px;
}

.character {
  position: absolute;
  top: 20px;
  right: 20px;
  font-family: chinese;
  z-index: -1;
  color: #B44646;
}
.grid {
  width: 120px;
  height: 120px;
  border-collapse: collapse;
}
.grid td {
  border: 1px solid #303030;
}

.label {
  position: relative;
  font-size: 80px;
}
.secondary_label {
  font-size: 40px;
  cursor: pointer;
}
.secondary_label:hover {
  color: #B44646;
}

.field_description {
  font-size: 12px;
  color: rgba(0,0,0,0.54);
}

.variants {
  display: flex;
  flex-direction: row;
}
.variant {
  font-size: 20px;
  margin-right: 10px;
}
</style>
