module.exports =
  id: 'horoscop'
  title: 'Horoscop'
  lang: 'ro'
  routes: [
    ['get', '/', 'index']
    ['get', '/:date', 'index']
  ]
