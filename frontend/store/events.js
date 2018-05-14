import { Deserializer } from 'jsonapi-serializer'
import moment from 'moment'

export const state = () => ({
  index: [{
    title: 'Loading...'
  }]
})

export const actions = {
  get({commit}) {
    return this.$waterwheel.jsonapi.get('node/event', {
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