<template>
  <div class="chinesetext_section">
    
    <div class="chinese_text">
      <div>
        <div class="label">{{target.label}}</div>
        <div class="field_description">Chinese</div>
      </div>  
      <div v-if="target.radical !== undefined">
        <div class="secondary_label">{{target.radical}}</div>
        <div class="field_description">radical</div>
      </div>
    </div>
    
    <div v-if="target.pinyin !== undefined">
      <div>{{pinyin}}</div>
      <div class="field_description">pinyin</div>
    </div>
    <div v-if="target.zhuyin_fuhao !== undefined">
      <div>{{target.zhuyin_fuhao}}</div>
      <div class="field_description">zhuyin fuhao</div>
    </div>
    <div v-if="target.simplified !== undefined && target.simplified !== ''">
      <div>{{target.simplified}}</div>
      <div class="field_description">simplified form</div>
    </div>
  </div>
</template>

<script lang="coffee">
import PinyinConverter from '../../lib/pinyin_converter.js'

export default {

  computed:
    target: () -> @$store.state.target
    pinyin: () -> if @target.pinyin and @target.tone then PinyinConverter.convert("#{@target.pinyin}#{@target.tone}") else @target.pinyin

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

.label {
  font-size: 80px;
}
.secondary_label {
  font-size: 40px;
}

.field_description {
  font-size: 12px;
  color: rgba(0,0,0,0.54);
}

</style>
