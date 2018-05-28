<template>
  <b-pagination
    v-model="position"

    :per-page="data.perPage"
    :total-rows="data.totalRows"

    class="component__pager"
    hide-goto-end-buttons
    next-text='<span class="arrow__forward" />'
    prev-text='<span class="arrow__back" />' />
</template>

<script>
  import { mapState } from 'vuex'

  export default {
    computed: {
      data () {

        return {
          perPage: this.perPage,
          totalRows: this.debug ? 5 * this.perPage : this.totalRows
        }
      },

      ...mapState({
        debug: state => state.debug
      })
    },

    data () {
      return {
        'position': 1
      }
    },

    methods: {
      update () {
        this.$emit('input', this.position)
      }
    },

    props: ['per-page', 'total-rows'],

    watch: {
      'position': 'update'
    }
  }
</script>

<style lang="scss">
  @import '~/assets/scss/styles.scss';

  $_arrow_size: 8px;
  $_color: $color__matisse;
  $_border_color: #e9e9e9;
  $_border_size: 3px;
  $_size: 48px;

  .component__pager {
    display: inline-flex;
    margin-bottom: 0;

    .arrow__back {
      @include misc__arrow(left, $_arrow_size, $_color, ($_size - $_arrow_size) / 2 - $_border_size, $_size - $_arrow_size);
    }

    .arrow__forward {
      @include misc__arrow(right, $_arrow_size, $_color, ($_size - $_arrow_size) / 2 - $_border_size, $_size - $_arrow_size);
    }

    .page-item.disabled .page-link,
    .page-item:first-child .page-link,
    .page-item:last-child .page-link,
    .page-link {
      border: {
        color: $_border_color;
        radius: 0;
        width: $_border_size;
      }
      color: $_color;
      display: block;
      font: {
        size: 13px;
        weight: 600;
      }
      height: $_size;
      line-height: 26px;
      margin-left: -$_border_size;
      text-align: center;
      width: $_size + 1px;
    }
    
    .page-item:first-child .page-link {
      margin-left: 0;
    }

    .page-item.active .page-link {
      background-color: $_color;
      border-color: $_color;
    }
  }
</style>
