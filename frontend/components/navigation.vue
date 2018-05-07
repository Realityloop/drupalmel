<template>
  <b-navbar toggleable="md" type="dark" variant="dark">

    <b-navbar-toggle target="nav_collapse"></b-navbar-toggle>

    <b-navbar-brand href="#">DrupalMelbourne</b-navbar-brand>

    <b-collapse is-nav id="nav_collapse">

      <b-navbar-nav v-for="(value, id) in index" :key="id">
        <b-nav-item v-if="value" :href="`#` + id">{{ value }}</b-nav-item>
      </b-navbar-nav>

    </b-collapse>
  </b-navbar>
</template>

<script>
import { mapState } from "vuex";

export default {
  computed: {
    ...mapState({
      // Current pages index.
      index: state => state.index
    })
  }
};
</script>
