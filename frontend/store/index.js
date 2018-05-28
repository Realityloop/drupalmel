export const state = () => ({
  debug: false,
  index: {}
})

export const actions = {
  async index({ commit, dispatch }, data) {
    commit('set', data)

    // Fetch required data for applicable items.
    for (let item in data) {
      if (typeof data[item] == 'object' && typeof data[item].fetch !== 'undefined') {
        await dispatch(data[item].fetch)
      }
    }
  }
}

export const mutations = {
  debug (state, value) {
    state.debug = value
  },

  set (state, data) {
    state.index = data
  }
}
