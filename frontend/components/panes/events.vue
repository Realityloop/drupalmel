<template>
  <b-card title="Events">
    asdf
  </b-card>
</template>

<script>
import { mapActions } from 'vuex'

export default {
  methods: {
    ...mapActions({
      eventsGet: 'events/get'
    })
  },

  mounted () {
    this.eventsGet()
  },

  fetch ({ app, store, params }) {
    return store.dispatch('events/get')
  }
}
</script>

<style lang="sass" scoped>

</style>
