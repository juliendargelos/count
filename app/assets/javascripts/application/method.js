Application.Method = class Method {
  constructor(element) {
    this.element = element

    this.form = document.createElement('form')
    this.form .method = 'post'
    var token = document.createElement('input')
    token.name = 'authenticity_token'
    token.value = document.querySelector('meta[name="csrf-token"]').getAttribute('content')
    this.input = document.createElement('input')
    this.input.name = '_method'

    this.form.appendChild(token)
    this.form.appendChild(this.input)

    this.verb = this.element.getAttribute('data-method') || 'get'
    this.url = this.element.getAttribute('href')
    this.confirm = Application.Confirm.for(this.element)

    this.click = event => {
      event.preventDefault()
      if(!this.confirm || this.confirm.confirmed) this.send()
    }

    this.enable()

    this.constructor.all.push(this)
  }

  get verb() {
    return this.input.value
  }

  set verb(v) {
    this.input.value = v
  }

  get url() {
    return this.form.action
  }

  set url(v) {
    this.form.action = v
  }

  send() {
    this.form.submit()
  }

  enable() {
    this.element.addEventListener('click', this.click)
  }

  disable() {
    this.element.removeEventListener('click', this.click)
  }

  static find(element) {
    return this.all.find(method => method.element === element)
  }

  static for(element) {
    return this.find(element) || new this(element)
  }

  static init(scope) {
    return Application.initializing(this, {
      scope: scope,
      forData: 'method'
    })
  }
}
