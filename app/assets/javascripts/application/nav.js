Application.Nav = class Nav {
  static get selected() {
    return this.buttons.find(button => button.classList.contains('button--selected'))
  }

  static set selected(v) {
    this.buttons.forEach(button => button.classList.remove('button--selected'))
    if(v) v.classList.add('button--selected')
    this.resizeIndicator()
  }

  static get indicatorLeft() {
    return parseFloat(this.indicator.style.transform.replace(/translate\(\s*(.+)?px/, '$1'), 10) || 0
  }

  static set indicatorLeft(v) {
    this.indicator.style.transform = 'translate(' + v + 'px, -100%)'
  }

  static get indicatorWidth() {
    return this.indicator.offsetWidth
  }

  static set indicatorWidth(v) {
    this.indicator.style.width = v + 'px'
  }

  static get buttons() {
    return Array.prototype.slice.call(this.element.querySelectorAll('.nav__item .button'))
  }

  static resizeIndicator() {
    var selected = this.selected

    if(selected) this.indicatorLeft = selected.offsetLeft
    this.indicatorWidth = selected ? selected.offsetWidth : 0
  }

  static init(scope) {
    return Application.initializing(this, {
      scope: scope,
      init: scope => {
        if(scope === document) {
          this.element = scope.querySelector('.nav')
          if(this.element) {
            this.indicator = this.element.querySelector('.nav__indicator')

            setTimeout(() => this.resizeIndicator(), 1)
            window.addEventListener('resize', () => this.resizeIndicator())
          }
        }
      }
    })
  }
}
