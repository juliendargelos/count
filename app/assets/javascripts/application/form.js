Application.Form = class Form {
  constructor(element) {
    this.element = element
    this.sendingCounter = 0
    this.inputs = Array.prototype.slice.call(this.element.querySelectorAll('.form__input'))

    if(this.element.id) {
      this.inputs = this.inputs.concat(Array.prototype.slice.call(
        document.querySelectorAll('.form__input[form="' + this.element.id + '"]')
      ))
    }

    this.inputs = this.inputs.map(element => this.constructor.Input.for(element))

    this.constructor.Association.init(this.element)

    this.constructor.all.push(this)
  }

  get auto() {
    return this._input
  }

  set auto(v) {
    this._inputs = !!v
    this.inputs.forEach(input => { input.auto })
  }

  get method() {
    return this.element.method
  }

  get url() {
    return this.element.action
  }

  get request() {
    var request = new Request(this.url, this.method)
    request.form = this.element

    return request
  }

  get sending() {
    return this.sendingCounter !== 0
  }

  send(callback) {
    this.sendingCounter++
    var promise = this.request.send().then(() => {
      callback.call(this)
      this.sendingCounter--
    })

    return promise
  }

  static for(element) {
    return this.all.find(form => form.element === element) || new this(element)
  }

  static in(element) {
    return Application.instanciate(this, {selector: '.form', by: element => this.for(element)}, element)
  }

  static init(scope) {
    this.Input.init(scope)

    return Application.initializing(this, {
      scope: scope,
      init: scope => this.in(scope),
      collect: true
    })
  }
}
