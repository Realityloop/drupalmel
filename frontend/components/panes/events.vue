<template>
  <b-container class="pane__events">
    <b-row>

      <b-col><h2>Events</h2></b-col>

    </b-row>
    <b-row>

      <b-col lg="6" class="events">
        <b-list-group
          v-for="(event, delta) in index"
          v-if="isVisible(delta)"

          :key="delta">
          <dm-events-event
            :active="isActive(delta)"
            :delta="delta"
            :event="event" />
        </b-list-group>

        <b-pagination
          :per-page="pagination.items"
          :total-rows="index.length"
          v-model="pagination.position" />
      </b-col>

      <b-col class="map">
        <no-ssr>
          <l-map :zoom=17 :center="mapPosition">
            <l-tile-layer url="http://{s}.tile.osm.org/{z}/{x}/{y}.png"></l-tile-layer>
            <l-marker :lat-lng="mapPosition"></l-marker>
          </l-map>
        </no-ssr>
      </b-col>

    </b-row>
  </b-container>
</template>

<script>
import { mapState, mapMutations } from "vuex";

export default {
  computed: {
    mapPosition () {
      let location = this.index[this.active].location

      return [location.lat, location.lng]
    },

    ...mapState({
      // Active event.
      active: state => state.events.active,

      // Events index.
      index: state => state.events.index
    })
  },

  data() {
    return {
      fields: {
        title: {},
        time: {
          label: "Date",
          sortable: true
        }
      },

      pagination: {
        items: 3,
        position: 1
      }
    };
  },

  methods: {
    isActive (delta) {
      if (!this.isVisible(this.active)) {
        this.activate(delta)
      }

      return delta == this.active
    },

    isVisible (delta) {
      return delta >= this.pagination.items * (this.pagination.position - 1)
        && delta < this.pagination.items * this.pagination.position
    },

    ...mapMutations({
      activate: 'events/activate'
    })
  }
};
</script>

<style lang="scss" scoped>
  .map {
    overflow: hidden;
    margin-left: -20px;
  }
</style>
