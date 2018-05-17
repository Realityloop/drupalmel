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

  h1,
  h2,
  h3,
  h4 {
    font-family: $type__font__oswald;
  }

  h2 {
    font-size: $type__size__default;
    text-transform: uppercase;
  }

  h5 {
    font-size: 1rem;
  }
</style>
