export const state = () => ({
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
  set (state, data) {
    state.index = data
  }
}
