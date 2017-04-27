<template>
  <div class="chinesetext_section">
    
    <div class="label">{{target.label}}</div>
    <div v-if="target.radical !== undefined">
      <div class="field_description">radical</div>
      <div class="secondary_label">{{target.radical}}</div>
    </div>
    
    <div class="other_info">
      <div v-if="target.zhuyin_fuhao !== undefined">
        <div class="field_description">zhuyin fuhao</div>
        <div>{{target.zhuyin_fuhao}}</div>
      </div>
      <div v-if="target.simplified !== undefined && target.simplified !== ''">
        <div class="field_description">simplified form</div>
        <div>{{target.simplified}}</div>
      </div>
      <div v-if="target.pinyin !== undefined">
        <div class="field_description">pinyin</div>
        <div>{{pinyin}}</div>
      </div>
    </div>
  </div>
</template>

<script lang="coffee">
import PinyinConverter from '../../lib/pinyin_converter.js'

export default {

  computed:
    target: () -> @$store.state.target
    pinyin: () -> PinyinConverter.convert("#{@target.pinyin}#{@target.tone}")

}
</script>

<style scoped>
.chinesetext_section {
  display: flex;
  flex-direction: row;
  align-items: center;
  padding: 16px;
}

.label {
  margin-right: 20px;
  font-size: 80px;
}
.secondary_label {
  font-size: 40px;
  margin-right: 40px;
}

.field_description {
  font-size: 12px;
  color: rgba(0,0,0,0.54);
}

</style>
