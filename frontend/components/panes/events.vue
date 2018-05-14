<template>
  <b-card title="Upcoming events">

    <b-table
      :current-page="pagination.position"
      :fields="fields"
      :items="index"
      :per-page="pagination.items"

      hover
      striped>

      <template slot="time" slot-scope="data">
        {{ data.item.time | moment('DD/MM/YYYY - HH:mm') }}
      </template>

    </b-table>

    <b-pagination
      :per-page="pagination.items"
      :total-rows="index.length"
      v-model="pagination.position" />

  </b-card>
</template>

<script>
import { mapActions, mapState } from 'vuex'

export default {
  computed: {
    ...mapState({
      // Events index.
      index: state => state.events.index
    })
  },

  data () {
    return {
      fields: {
        'title': {},
        'time': {
          label: 'Date',
          sortable: true
        }
      },

      pagination: {
        items: 5,
        position: 1
      }
    }
  },

  methods: {
    ...mapActions({
      eventsGet: 'events/get'
    })
  },

  mounted () {
    // Load Events.
    this.eventsGet()
  },
}
</script>

<style lang="sass" scoped>

</style>
