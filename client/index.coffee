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
    @renderText = $ '#render-text'
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

  setup: ->
    @renderDay '2014-04-10'

  renderDay: (day) ->
    @renderText.empty()
    for i in [0 .. 11]
      @makeSign day, i
      .appendTo @renderText
    return

  makeSign: (day, i) ->
    ret = $ '<div class="sign"/>'
    @makeBubble '#', @signs[i][0], @signs[i][2]
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
