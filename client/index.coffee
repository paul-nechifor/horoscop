seedrandom = require 'seedrandom'

main = ->
  $.ajax
    url: window.staticPath + '/lines'
  .done (data) ->
    lines = data.split '\n'
    if lines[lines.length - 1].length is 0
      lines.splice lines.length - 1, 1
    page = new Page lines
    page.setup()

class Page
  constructor: (@lines) ->
    @day = window.location.pathname.substring window.rootPath.length
    @day = new Date().toISOString().substring(0, 10) unless @day
    @renderText = $ '#render-text'
    @dateControls = $ '#date-controls'
    @signs = [
      ['♈', 'berbec', 'Berbec']
      ['♉', 'taur', 'Taur']
      ['♊', 'gemeni', 'Gemeni']
      ['♋', 'rac', 'Rac']
      ['♌', 'leu', 'Leu']
      ['♍', 'fecioara', 'Fecioară']
      ['♎', 'balanta', 'Balanță']
      ['♏', 'scorpion', 'Scorpion']
      ['♐', 'sagetator', 'Săgetător']
      ['♑', 'capricorn', 'Capricorn']
      ['♒', 'varsator', 'Vărsător']
      ['♓', 'pesti', 'Pești']
      ['∞', 'toate', 'Toate']
    ]
    @months = [
      'ianuarie'
      'februarie'
      'martie'
      'aprilie'
      'mai'
      'iunie'
      'iulie'
      'august'
      'septembrie'
      'octombrie'
      'noiembrie'
      'decembrie'
    ]

  setup: ->
    @renderDay @day

  renderDay: (day) ->
    @renderDateControls day
    @renderText.empty()
    for i in [0 .. 11]
      @makeSign day, i
      .appendTo @renderText
    return

  renderDateControls: (day) ->
    date = @getDate day
    stamp = date.getTime()
    inDay = 1000 * 60 * 60 * 24
    @setHref @dateControls.find('.prev a'), stamp - inDay, '◃ ', '', true
    @setHref @dateControls.find('.next a'), stamp + inDay, '', ' ▹', true
    @setHref @dateControls.find('.curr a'), stamp, '', ' ' + date.getFullYear()


  setHref: (a, stamp, before, after, shortMonth) ->
    p = (x) -> if x < 10 then '0' + x else x
    d = new Date stamp
    month = @months[d.getMonth()]
    month = month.substring(0, 3) + '.' if shortMonth
    code = "#{p d.getFullYear()}-#{p d.getMonth() + 1}-#{p d.getDate()}"
    a.attr 'href', window.rootPath + code
    .text "#{before}#{d.getDate()} #{month}#{after}"

  getDate: (day) ->
    p = day.split('-').map (x) -> Number x
    new Date p[0], p[1] - 1, p[2]

  makeSign: (day, i) ->
    ret = $ '<div class="sign"/>'
    .attr 'id', @signs[i][1]
    @makeBubble '#' + @signs[i][1], @signs[i][0], @signs[i][2]
    .appendTo ret
    $ '<p class="text"/>'
    .text @getText day + '/' + i
    .appendTo ret
    ret

  makeBubble: (href, top, bottom) ->
    inner = $ '<a class="bubble-inner"/>'
    .attr 'href', href
    .append $('<span class="top"/>').text top
    .append document.createTextNode ' '
    .append $('<span class="bottom"/>').text bottom
    $ '<p class="bubble"/>'
    .append inner

  getText: (seed) ->
    rng = seedrandom seed
    sentances = 3 + Math.floor rng() * 2
    lines = []
    while lines.length < sentances
      l = Math.floor rng() * @lines.length
      found = false
      for x in lines
        if x is l
          found = true
          break
      continue if found
      lines.push l
    lines.map((l) => @lines[l]).join ' '

main()
