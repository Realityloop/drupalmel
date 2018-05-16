<template>
  <b-list-group-item
    @click="click(delta)"

    :class="classes">
    <b-row cols="6" align-v="center">

      <b-col order="1"><h5 class="title">{{ event.title }}</h5></b-col>

      <b-col cols="2" order="0" class="datetime">
        <span class="date">{{ event.time | moment('DD/MM') }}</span>
        <span class="time">{{ event.time | moment('HH:mm') }}</span>
      </b-col>

    </b-row>
  </b-list-group-item>
</template>

<script>
  import { mapMutations } from "vuex";

  export default {
    computed: {
      classes () {
        let base = "component__events__event"
        let classes = [base]

        if (this.active) {
          classes.push("active")
          classes.push(base + "--active")
        }
        else {
          classes.push(base + "--default")
        }
        classes.push(this.delta % 2 ? "odd" : "even")

        return classes.join(' ')
      }
    },

    methods: {
      ...mapMutations({
        click: 'events/activate'
      })
    },

    props: ['active', 'delta', 'event']
  }
</script>

<style lang="scss" scoped>
  @import '~/assets/scss/styles.scss';

  .component__events__event {
    border: {
      color: transparent;
      radius: 0;
      width: 3px;
    }
    height: 60px;
    padding: 10px;

    .title {
      margin-bottom: 0;
      position: relative;
    }

    .datetime {
      color: $color__blue--primary;

      .date {
        display: block;
      }

      .time {
        display: block;
      }
    }

    &--active {
      background-color: $color__white;
      border-color: $color__blue--primary;
      color: inherit;

      .title::after {
        border: {
          bottom: 11px solid transparent;
          left: 11px solid $color__blue--primary;
          top: 11px solid transparent;
        }
        content: '';
        display: block;
        height: 0;
        position: absolute;
        right: 0;
        top: 0;
        width: 0;
      }
    }
  }
</style>
