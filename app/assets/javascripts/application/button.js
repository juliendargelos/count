Application.Button = class Button {
  constructor(element) {
    this.element = element
  }

  get element() {
    return this._element
  }

  set element(v) {
    if(!(v instanceof HTMLElement)) v = document.createElement('span')
    v.classList.add('button')

    this._element = v
  }

  get type() {
    return this.constructor.types.find(type => this.element.classList.contains('button--' + type)) || 'base'
  }

  set type(v) {
    v = this.constructor.type(v)
    this.element.classList.remove(...this.constructor.types.map(type => 'button--' + type))
    if(v !== 'base') this.element.classList.add('button--' + v)
  }

  get label() {
    return this.element.textContent
  }

  set label(v) {
    this.element.textContent = v
  }

  static type(name) {
    return this.types.find(type => name === type) || 'base'
  }

  static get types() {
    return ['primary', 'secondary', 'danger']
  }

  static base(label, callback) {
    var button = new this()
    button.label = label
    if(typeof callback === 'function') button.element.addEventListener('click', callback)

    return button
  }

  static primary(label, callback) {
    var button = this.base(label, callback)
    button.type = 'primary'

    return button
  }

  static secondary(label, callback) {
    var button = this.base(label, callback)
    button.type = 'secondary'

    return button
  }

  static danger(label, callback) {
    var button = this.base(label, callback)
    button.type = 'danger'

    return button
  }
}
