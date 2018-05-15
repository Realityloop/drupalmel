import { Deserializer } from 'jsonapi-serializer'

export const state = () => ({
  index: []
})

export const actions = {
  async get({ commit }) {
    await this.$waterwheel.jsonapi.get('node/event', {
      fields: {
        'node--event': 'title,location,meetup_id,time'
      },
      sort: 'time',
    })

      .then(res => new Deserializer({
        keyForAttribute: 'camelCase'
      })

        .deserialize(res, (err, data) => {
          if (!err) {
            return data
          }
        }))

      .then(res => {
        commit('set', res)
      })
  }
}

export const mutations = {
  set(state, res) {
    state.index = res
  }
}