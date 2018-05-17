<template>
  <div>
    <dm-navigation />

    LOGO

    <nuxt/>
  </div>
</template>

<style lang="scss">
  @import '~/assets/scss/styles.scss';
  @import '~/assets/scss/bootstrap.scss';

  * {
    color: $type__color__default;
    font: {
      family: $type__font__default;
      size: $type__size__default;
    }
    line-height: $type__line_height__default;
  }

  h5 {
    font-size: 1rem;
  }
</style>
