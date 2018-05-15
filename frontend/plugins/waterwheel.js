// @see https://github.com/acquia/waterwheel.js/issues/77 
import Waterwheel from 'waterwheel/lib/waterwheel'

const waterwheel = new Waterwheel({
  base: 'http://cms.' + process.env.PROJECT_BASE_URL,
  oauth: {
    grant_type: 'password',
    client_id: process.env.API_CONSUMER_CLIENT_ID,
    client_secret: process.env.API_CONSUMER_CLIENT_SECRET,
    username: process.env.API_CONSUMER_USERNAME,
    password: process.env.API_CONSUMER_PASSWORD
  },
  timeout: process.env.API_TIMEOUT || 2500,
  jsonapiPrefix: 'api'
})

export default (ctx) => {
  const { app, store } = ctx

  app.$waterwheel = waterwheel
  ctx.$waterwheel = waterwheel
  if (store) {
    store.$waterwheel = waterwheel
  }
}
