<template>
  <b-list-group-item
    @click="click(delta)"

    :class="classes">
    <b-row cols="6" align-v="center">

      <b-col order="1" class="title"><h5>{{ event.title }}</h5></b-col>

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

  $_arrow_size: 8px;
  $_arrow_color: $color__blue--primary;
  $_border_width: 3px;
  $_height: 60px;
  $_padding: 10px;
  $_line_height: $_height - ($_border_width + $_padding) * 2;

  .component__events__event {
    background-color: transparent;
    border: {
      color: transparent;
      radius: 0;
      width: $_border_width;
    }
    cursor: pointer;
    height: $_height;
    padding: $_padding;

    .title {
      position: relative;
      padding-left: 0;

      h5 {
        line-height: $_line_height;
        margin-bottom: 0;
      }
    }

    .datetime {
      .date,
      .time {
        color: $color__blue--primary;
        display: block;
        line-height: $_line_height / 2 + 2px;
      }
    }

    &.even {
      background-color: $color__white;
    }

    &--active {
      background-color: $color__white;
      border-color: $color__blue--primary;
      color: inherit;

      // @TODO - Make this a mixin (arrow).
      .title {
        @include misc__arrow($_arrow_size, $_arrow_color, $_padding, $_line_height);
      }
    }
  }
</style>
