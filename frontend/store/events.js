export const state = () => ({
  index: {}
})

export const actions = {
  get (state) {
    this.$waterwheel.jsonapi.get('node/events', {})
      .then(res => {
        console.log(res)
        return {}
      })
    state.index = { 'test': true }
  }
}
