import seedrandom from 'seedrandom';
import lines from './lines';

function main() {
  new Page(lines).setup();
}

class Page {
  constructor(lines) {
    this.lines = lines;
    this.renderText = $('#render-text');
    this.dateControls = $('#date-controls');
    this.signs = [
      ['♈', 'berbec', 'Berbec'],
      ['♉', 'taur', 'Taur'],
      ['♊', 'gemeni', 'Gemeni'],
      ['♋', 'rac', 'Rac'],
      ['♌', 'leu', 'Leu'],
      ['♍', 'fecioara', 'Fecioară'],
      ['♎', 'balanta', 'Balanță'],
      ['♏', 'scorpion', 'Scorpion'],
      ['♐', 'sagetator', 'Săgetător'],
      ['♑', 'capricorn', 'Capricorn'],
      ['♒', 'varsator', 'Vărsător'],
      ['♓', 'pesti', 'Pești'],
      ['∞', 'toate', 'Toate'],
    ];
    this.months = [
      'ianuarie',
      'februarie',
      'martie',
      'aprilie',
      'mai',
      'iunie',
      'iulie',
      'august',
      'septembrie',
      'octombrie',
      'noiembrie',
      'decembrie',
    ];
  }

  setup() {
    this.renderDay(this.getDay());
    window.addEventListener('hashchange', () => {
      this.renderDay(this.getDay());
    }, false);
  }

  getDay() {
    const day = window.location.hash.replace('#', '');
    return day ? day : new Date().toISOString().substring(0, 10);
  }

  renderDay(day) {
    this.renderDateControls(day);
    this.renderText.empty();
    for (let i = 0; i <= 11; i++) {
      this.makeSign(day, i)
      .appendTo(this.renderText);
    }
  }

  renderDateControls(day) {
    let date = this.getDate(day);
    let stamp = date.getTime();
    let inDay = 1000 * 60 * 60 * 24;
    this.setHref(this.dateControls.find('.prev a'), stamp - inDay, '◃ ', '', true);
    this.setHref(this.dateControls.find('.next a'), stamp + inDay, '', ' ▹', true);
    return this.setHref(this.dateControls.find('.curr a'), stamp, '', ` ${date.getFullYear()}`);
  }


  setHref(a, stamp, before, after, shortMonth) {
    let p = function(x) { if (x < 10) { return `0${x}`; } else { return x; } };
    let d = new Date(stamp);
    let month = this.months[d.getMonth()];
    if (shortMonth) {
      month = month.substring(0, 3) + '.';
    }
    let code = `${p(d.getFullYear())}-${p(d.getMonth() + 1)}-${p(d.getDate())}`;
    return a.attr('href', `#${code}`)
    .text(`${before}${d.getDate()} ${month}${after}`);
  }

  getDate(day) {
    let p = day.split('-').map(x => Number(x));
    return new Date(p[0], p[1] - 1, p[2]);
  }

  makeSign(day, i) {
    let ret = $('<div class="sign"/>')
    .attr('id', this.signs[i][1]);
    this.makeBubble(`#${this.signs[i][1]}`, this.signs[i][0], this.signs[i][2])
    .appendTo(ret);
    $('<p class="text"/>')
    .text(this.getText(day + '/' + i))
    .appendTo(ret);
    return ret;
  }

  makeBubble(href, top, bottom) {
    let inner = $('<a class="bubble-inner"/>')
    .append($('<span class="top"/>').text(top))
    .append(document.createTextNode(' '))
    .append($('<span class="bottom"/>').text(bottom));
    return $('<p class="bubble"/>')
    .append(inner);
  }

  getText(seed) {
    let rng = seedrandom(seed);
    let sentances = 3 + Math.floor(rng() * 2);
    let lines = [];
    while (lines.length < sentances) {
      let l = Math.floor(rng() * this.lines.length);
      let found = false;
      for (let x of Array.from(lines)) {
        if (x === l) {
          found = true;
          break;
        }
      }
      if (found) { continue; }
      lines.push(l);
    }
    return lines.map(l => this.lines[l]).join(' ');
  }
}

main();
