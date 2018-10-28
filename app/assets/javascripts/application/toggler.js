Application.Toggler = class Toggler {
  constructor(element) {
    this.element = element

    this.element.addEventListener(this.event, () => this.toggle())
  }

  get selector() {
    return this.element.getAttribute('data-toggle')
  }

  get targets() {
    return document.querySelectorAll(this.selector)
  }

  get event() {
    return this.element.getAttribute('data-toggle-event') || 'click'
  }

  each(callback) {
    Array.prototype.forEach.call(this.targets, target => callback.call(this, target))
  }

  show() {
    this.each(target => this.constructor.show(target))
  }

  hide() {
    this.each(target => this.constructor.hide(target))
  }

  toggle() {
    this.each(target => this.constructor.toggle(target))
  }

  static hidden(element) {
    return element.getAttribute('hidden') !== null
  }

  static hide(element) {
    element.setAttribute('hidden', '')
  }

  static show(element) {
    element.removeAttribute('hidden')

    Application.Form.in(element).forEach(form => {
      form.inputs.forEach(input => {
        if(input.resizable) input.resize()
      })
    })
  }

  static toggle(element) {
    if(this.hidden(element)) this.show(element)
    else this.hide(element)
  }

  static init(scope) {
    return Application.initializing(this, {
      scope: scope,
      instanciate: '[data-toggle]'
    })
  }
}
