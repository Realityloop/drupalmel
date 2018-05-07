import Vue from 'vue'

// @TODO - Figure out how to dynamically import these files.
//       - 'fs' doesn't work due to webpack.

// Components.
import dmNavigation from '~/components/navigation.vue'

// Panes.
import dmPanesEvents from '~/components/panes/events.vue'
import dmPanesSplash from '~/components/panes/splash.vue'

let components = {
  dmNavigation,
  dmPanesEvents,
  dmPanesSplash
}

const dmComponents = {
  install: function (Vue) {
    if (Vue._dm_components_installed) {
      return
    }

    Vue._dm_components_installed = true

    // Register components
    for (var component in components) {
      Vue.component(component, components[component])
    }
  }
}

Vue.use(dmComponents)
