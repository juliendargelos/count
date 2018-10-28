Application.Focuser = class Focuser {
  constructor(element) {
    this.element = element

    this.element.addEventListener(this.event, () => this.focus())
  }

  get selector() {
    return this.element.getAttribute('data-focus')
  }

  get target() {
    return document.querySelector(this.selector)
  }

  get event() {
    return this.element.getAttribute('data-focus-event') || 'click'
  }

  focus() {
    this.target.focus()
  }

  static init(scope) {
    return Application.initializing(this, {
      scope: scope,
      instanciate: '[data-focus]',
    })
  }
}
