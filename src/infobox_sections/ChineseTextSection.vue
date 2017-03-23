<template>
  <div class="chinesetext_section">
    
    <div class="main_info">
      <span class="label">{{target.label}}</span>
      <span class="secondary_label">{{target.radical}}</span>
    </div>
    
    <div class="other_info">
      <div v-if="target.zhuyin_fuhao !== undefined">
        <div>{{target.zhuyin_fuhao}}</div>
        <div class="field_description">zhuyin fuhao</div>
      </div>
      <div v-if="target.simplified !== undefined && target.simplified !== ''">
        <div>{{target.simplified}}</div>
        <div class="field_description">forma semplificata</div>
      </div>
      <div v-if="target.pinyin !== undefined">
        <div>{{target.pinyin}}</div>
        <div class="field_description">pinyin</div>
      </div>
    </div>
  </div>
</template>

<script lang="coffee">
export default {

  computed:
    target: () -> @$store.state.target

}
</script>

<style scoped>
.chinesetext_section {
  padding: 16px;
  display: flex;
  align-items: center;
}
.main_info {
  margin-right: 40px;
}

.label {
  margin-right: 10px;
  font-size: 80px;
  font-family: chinese;
}
.secondary_label {
  font-size: 40px;  
}

.other_info {
  display: flex;
  flex-direction: column;
  font-size: 20px;
}

.field_description {
  font-size: 12px;
  color: rgba(0,0,0,0.54);
}

</style>
