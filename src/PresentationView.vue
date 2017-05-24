<template>
  <div class="presentationview">
    <div class="margin"></div>
    
    <header>
      <div v-if="space.label !== undefined" class="label" v-html="kgl(space.label)"></div>
      <div v-if="space.subtitle !== undefined" class="subtitle" v-html="kgl(space.subtitle)"></div>
      <div v-if="space.description !== undefined" class="description" v-html="kgl(space.description)"></div>
    </header>

    <div class="collections">
      <div v-for="c in collections" class="collection">
        <div class="signature">
          <div class="title">{{c.label}}</div>
          <div class="subtitle">{{c.subtitle}}</div>
          <button @click="open(c)">EXPLORE COLLECTION</button>
          <div v-if="previews[c.id] !== undefined" class="count">({{previews[c.id].subspaces.length}} item{{previews[c.id].subspaces.length == 1 ? '' : 's'}})</div>
        </div>
        <div class="previews">
          <div v-if="c.id in previews" class="inner_previews">
            <div v-if="p.vfs_img !== undefined" class="preview" v-for="p in previews[c.id].subspaces" :style="{'max-width': '250px','max-height': '250px'}" @click="open(p)">
              <div class="title">{{p.label}}</div>
              <div v-if="p.vfs_img !== undefined" class="img"
                   :style="{background: 'url('+p.vfs_img+')'}"></div>
            </div>
          </div>
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
import kgl from './infobox_sections/kgl.coffee'

export default {
  mounted: () ->
    @collections.forEach (c) => @$store.dispatch 'request_previews', c.id

  computed:
    space: () -> @$store.state.space
    collections: () -> @$store.state.space.subspaces.sort (a,b) -> 
      if a.order? and b.order?
        return a.order - b.order
      else
        if not a.width?
          a.width = 1
        if not b.width?
          b.width = 1

        if b.width is a.width
          return b.label < a.label
        else
          return b.width - a.width
    previews: () -> if @$store.state.previews? then @$store.state.previews else {}
    footer_sections: () -> JSON.parse(@$store.state.space.sections)

  watch:
    previews: (newPreviews) -> @previews = newPreviews

  methods:
    kgl: (d) -> kgl.parse d, @$store.state.space
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
  padding-top: 32px; /* FIXME this is because of the breadcrumb, but we need a more intelligent way to do this */
  padding-left: 430px; /* 12px more, needed for folders margin */
  padding-right: 30px;
  box-sizing: border-box;
}

header {
  position: absolute;
  top: 0;
  left: 0;
  width: var(--left-panel-width);
  box-sizing: border-box;
}
header .label {
  margin-top: 32px;
  padding-left: 30px;
  font-size: 30px;
  font-weight: 300;
}
header .subtitle {
  margin-top: 20px;
  padding-left: 30px;
  font-size: 20px;
  font-weight: 300;
  color: #333;
}
header .description {
  margin-top: 20px;
  padding-left: 30px;
  font-size: 16px;
  font-weight: 300;
}

footer {
  padding-left: 30px;
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
  padding: 50px;
  background: #FFF;
  margin-bottom: 25px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.2), 0 -1px 0px rgba(0,0,0,0.02);
}
.collection .signature {
  width: 250px;
  margin: 0px 50px 20px 0px;
}
.collection .signature .title {
  font-size: 28px;
  font-weight: 300;
  line-height: 1.2em;
  margin-bottom: 20px;
}
.collection .signature .subtitle {
  line-height: 24px;
  font-size: 14px;
  font-weight: 300;
  margin-bottom: 50px;
}
.collection .signature button {
  background-color: transparent;
  border: 2px solid #e0e0e0;
  border-radius: 3px;
  padding: 8px;
  font-family: Roboto;
  font-size: 14px;
  cursor: pointer;
  margin-bottom: 10px;
}
.collection .signature button:hover {
  background: #e0e0e0;
}
.collection .signature .count {
  font-size: 12px;
  font-weight: 300;
}

.collection .previews {
  width: calc(100% - 250px)
}
.collection .preview {
  position: relative;
  margin: 5px;
  width: 45%;
  height: 180px;
  cursor: pointer;
}
.collection .preview .img {
  height: 100%;
  background-position-x: center !important;
  background-size: cover !important;
  background-repeat: no-repeat !important;
}
.collection .preview .title {
  position: absolute;
  bottom: 0;
  box-sizing: border-box;
  width: 100%;
  padding: 60px 10px 10px 10px;

  background-image: linear-gradient(to top,rgba(0,0,0,.4) 0,transparent 100%);
  
  font-size: 14px;

  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  color: #fff;
}
.collection .inner_previews {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
}

.credits {
  position: absolute;
  bottom: 10px;
  left: 10px;
  font-size: 11px;
  font-weight: 300;
  width: 408px;
  padding-top: 10px;
}
</style>
