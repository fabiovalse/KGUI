<template>
  <div class="mailingsection">
    <div class="sender">
      <div class="img"><i class="icon-user-circle"></i></div>
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
      <div class="img"><i class="icon-user-circle"></i></div>
      <div class="info">
        <div class="name">{{space.recipient}}</div>
        <div class="place">{{space.recipient_place}}</div>
      </div>
    </div>
  </div>
</template>

<script lang="coffee">

export default {
  computed:
    space: () -> @$store.state.selection.space
}
</script>

<style scoped>
.mailingsection {
  margin-top: 30px;
}
.mailingsection .sender, .mailingsection .recipient {
  display: flex;
  color: #333;
  font-weight: 300;
}
.mailingsection .name {
  font-size: 20px;
  font-weight: 300;
}
.mailingsection .img {
  font-size: 60px;
  color: rgba(0,0,0,0.54);
  margin-right: 25px;
}
.mailingsection .mail {
  display: flex;
  align-items: center;
  margin: 0px 0px 10px 15px;
  font-size: 22px;
  color: rgba(0,0,0,0.3);
}
.mailingsection .mail .arrow {
  margin-top: -8px;
  font-size: 30px;
  -webkit-transform: rotate(180deg);
  -moz-transform: rotate(180deg);
  -ms-transform: rotate(180deg);
  -o-transform: rotate(180deg);
  filter: progid:DXImageTransform.Microsoft.BasicImage(rotation=3);
}
</style>
