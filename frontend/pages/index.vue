<template>
  <div>
    <section class="container" v-for="(title, id) in index" :key="id">
      <component :title="title" :is="`dm-panes-` + id" />
    </section>
  </div>
</template>

<script>
export default {
  data() {
    return {
      // Page compoent index.

      // - key:   Component id use to load file from
      //          `~/components/panes/{key}.vue`
      // - value: Human readable name, or `false` to exclude from navigation.
      index: {
        'splash': false,
        'events': 'Events'
      }
    };
  },

  fetch ({ app, store, params }) {
    // Populate the index store with this pages index.
    return store.commit('index', this.data().index)
  }
};
</script>
