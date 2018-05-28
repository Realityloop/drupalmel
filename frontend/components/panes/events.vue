<template>
  <b-container class="pane__events">
    <b-row>
      <b-col lg="6" class="events">
        <dm-heading-row>Events</dm-heading-row>

        <b-row>
          <b-col>
            <b-list-group>
              <dm-events-event
                v-for="(event, delta) in index"
                v-if="isVisible(delta)"

                :active="isActive(delta)"
                :delta="delta"
                :event="event"
                :key="delta" />
            </b-list-group>

            <div class="pager">
              <dm-pager
                v-model="pagination.position"

                :per-page="pagination.items"
                :total-rows="index.length" />
            </div>
          </b-col>
        </b-row>
      </b-col>

      <b-col class="map" v-if="!debug">
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

      // Debu state.
      debug: state => state.debug,

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

<style lang="scss">
  @import '~/assets/scss/styles.scss';

  .pane__events {
    box-shadow: 0px 13px 0px -10px $color__blue--primary;
    margin-bottom: 3px;

    .list-group {
      height: 180px;
    }
  }

  .events > .row > .col > *,
  .pager {
    // @TODO - make and name variable :(
    background-color: #fcfcfc;
    //background-color: red;
  }

  .pager {
    padding: 39px 0 19px;
    text-align: center;
  }

  .map {
    overflow: hidden;
    margin-left: -20px;
  }
</style>
