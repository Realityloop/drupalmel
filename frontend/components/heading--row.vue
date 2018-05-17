<template>
  <b-row class="component__heading--row">
    <b-col>
      <h2><slot /></h2>
    </b-col>
  </b-row>
</template>

<style lang="scss" scoped>
  @import '~/assets/scss/styles.scss';

  $_height: 60px;

  .component__heading--row {
    h2 {
      line-height: $_height;
      margin: 0;
      padding-left: $type__size__default;
    }
  }
</style>
