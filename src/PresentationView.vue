<template>
  <div class="presentationview">
    <div class="margin"></div>
    
    <header>
      <div class="title">{{space.title}}</div>
      <div class="subtitle">{{space.subtitle}}</div>

      <div class="description">{{space.description}}</div>
    </header>

    <div class="collections">
      <div v-for="c in collections" class="collection">
        <div class="signature">
          <div class="title">{{c.label}}</div>
          <div class="subtitle">{{c.subtitle}}</div>
          <button @click="open(c)">EXPLORE COLLECTION</button>
        </div>
        <div class="preview">
          a
        </div>
      </div>
    </div>

    <footer>
      <div v-for="sec in footer_sections" class="section">
        <div class="title">{{sec.label}}</div>
        <div class="items">
          <div v-for="item in sec.items">
            <a v-if="item.url !== undefined" :href="item.url" target="_blank">{{item.label}}</a>
            <span v-else>{{item.label}}</span>
          </div>
        </div>
      </div>
    </footer>

    <div class="credits">The UI of the Totus Mundus project is using <a href="https://github.com/fabiovalse/KGUI">KGUI</a>.</div>

  </div>
</template>

<script lang="coffee">
export default {
  computed:
    space: () -> @$store.state.space
    footer_sections: () -> JSON.parse(@$store.state.space.sections)
    collections: () -> @$store.state.space.subspaces.sort (a,b) -> 
      if not a.width?
        a.width = 1
      if not b.width?
        b.width = 1

      if b.width is a.width
        return b.label < a.label
      else
        return b.width - a.width

  methods:
    open: (item) -> 
      if item.view?
        @$store.dispatch 'change_space', item.id

      if item.template?
        @$store.dispatch 'select', {id: item.id}
}
</script>

<style scoped>
.presentationview {
  height: 100%;
  overflow-y: scroll;
  background: #f5f5f5;
  padding-top: 60px; /* FIXME this is because of the breadcrumb, but we need a more intelligent way to do this */
  padding-left: 430px; /* 12px more, needed for folders margin */
  box-sizing: border-box;
}

header {
  margin-top: 30px;
  color: rgba(0,0,0,0.87);
}
header .title {
  font-size: 35px;
  font-weight: 100;
}
header .subtitle {
  margin-top: 20px;
  font-size: 14px;
}
header .description {
  font-size: 15px;
  font-weight: 300;
  line-height: 1.7em;
  text-align: left;
  margin: 50px 24px 30px 0px;
}

footer .section {
  margin: 40px 0px 40px 0px;
}
footer .title {
  font-size: 20px;
  font-weight: 300;
  margin-bottom: 24px;
}
footer .items {
  font-size: 16px;
  font-weight: 300;
}

.collections {
  color: rgba(0,0,0,0.87);
}
.collection {
  display: flex;
  padding: 30px;
}
.collection:nth-child(odd) {
  background: #FFF;
}
.collection .signature {
  width: 270px;
  margin: 0px 50px 20px 0px;
}
.collection .title {
  font-size: 28px;
  font-weight: 100;
  line-height: 1.2em;
  margin-bottom: 20px;
}
.collection .subtitle {
  line-height: 24px;
  font-size: 14px;
  font-weight: 300;
  margin-bottom: 50px;
}
.collection .preview {
  flex-grow: 1;
}
.collection .signature button {
  background-color: transparent;
  border: 2px solid #e0e0e0;
  border-radius: 3px;
  padding: 8px;
  font-family: Roboto;
  font-size: 14px;
  cursor: pointer;
}
.collection .signature button:hover {
  background: #e0e0e0;
}

.credits {
  position: absolute;
  bottom: 10px;
  left: 10px;
  font-size: 11px;
  font-weight: 300;
  width: 200px;
  border-top: 1px solid rgba(0,0,0,0.4);
  padding-top: 10px;
}
</style>
