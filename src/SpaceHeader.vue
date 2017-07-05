<template>
  <header v-if="!hidden" :class="{overlay: overlay}">
    <div v-if="space.label !== undefined" class="label" v-html="kgl(space.label)"></div>

    <div class="mailing" v-if="space.view === 'manuscriptview'">
      <div class="sender">
        <div class="img"><i class="icon-user_circle"></i></div>
        <div class="info">
          <div class="name">{{space.sender}}</div>
          <div class="place">{{space.sender_place}}</div>
          <div class="date">{{space.date}}</div>
        </div>
      </div>
      <div class="mail">
        <div class="arrow"><i class="icon-arrow-up"></i></div>
        <div><i class="icon-email"></i></div>
      </div>
      <div class="recipient">
        <div class="img"><i class="icon-user_circle"></i></div>
        <div class="info">
          <div class="name">{{space.recipient}}</div>
          <div class="place">{{space.recipient_place}}</div>
        </div>
      </div>
    </div>
    <div v-else-if="space.subtitle !== undefined" class="subtitle" v-html="kgl(space.subtitle)"></div>

    <div v-if="space.description !== undefined" class="description" v-html="kgl(space.description)"></div>
  </header>
</template>

<script lang="coffee">
import kgl from './infobox_sections/kgl.coffee'

export default {
  props:
    overlay:
      type: Boolean
      'default': false
  computed:
    space: () -> @$store.state.selection.space
    hidden: () -> @space.hide_header # FIXME this should use cascading
  methods:
    kgl: (d) -> kgl.parse d, @space
}
</script>

<style scoped>
header {
  --margin: 16px;
  position: absolute;
  top: 0;
  left: 0;
  width: calc(var(--left-panel-width) - 2 * var(--margin));
  z-index: 3;
  margin: var(--margin);
  padding: var(--margin);
  box-sizing: border-box;
}
header .label {
  font-size: 30px;
  font-weight: 300;
  color: black;
}
header .subtitle {
  margin-top: 20px;
  font-size: 20px;
  font-weight: 300;
  color: #333;
}
header .description {
  margin-top: 20px;
  font-size: 16px;
  font-weight: 300;
  line-height: 1.2em;
  color: black;
}

/* overlay style */
header.overlay {
  background: rgba(0,0,0,0.6);
}
header.overlay .label,
header.overlay .subtitle,
header.overlay .description {
  color: white;
}

/* manuscript sender recipient */
header .mailing {
  margin-top: 30px;
}
header .mailing .sender, header .mailing .recipient {
  display: flex;
  color: #333;
  font-weight: 300;
}
header .mailing .name {
  font-size: 20px;
  font-weight: 300;
}
header .mailing .img {
  font-size: 60px;
  color: rgba(0,0,0,0.54);
  margin-right: 25px;
}
header .mailing .mail {
  display: flex;
  align-items: center;
  margin: 0px 0px 10px 15px;
  font-size: 22px;
  color: rgba(0,0,0,0.3);
}
header .mailing .mail .arrow {
  margin-top: -8px;
  font-size: 30px;
  -webkit-transform: rotate(180deg);
  -moz-transform: rotate(180deg);
  -ms-transform: rotate(180deg);
  -o-transform: rotate(180deg);
  filter: progid:DXImageTransform.Microsoft.BasicImage(rotation=3);
}
</style>
