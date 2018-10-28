Application.Form.Input = class Input {
  constructor(element) {
    this.watchers = []
    this.element = element
    this._auto = false
    this.updateInterval = 500
    this.updateTimeout = null
    this.updating = false

    if(this.resizable) {
      this.watch(this.resize)
      this.element.addEventListener('focus', () => this.resize())
      this.resize()
    }

    this.constructor.all.push(this)
  }

  static get minHeight() {
    return 25
  }

  get family() {
    return this.element.tagName.toLowerCase()
  }

  get resizable() {
    return this.family === 'textarea'
  }

  get type() {
    return this.element.type
  }

  get value() {
    return this.element.value
  }

  set value(v) {
    this.element.value = v
  }

  get form() {
    var element = this.element

    while(element.tagName !== 'FORM' && element.tagName !== 'BODY' && element.parentNode) {
      element = element.parentNode
    }

    return element.tagName === 'FORM' ? Application.Form.for(element) : null
  }

  get auto() {
    return this._auto
  }

  set auto(v) {
    v = !!v

    if(v !== this.auto) {
      this._auto = v
      this.watch(this.update)
    }
  }

  update() {
    var form = this.form

    if(!form || form.sending) return;

    clearTimeout(this.updateTimeout)
    this.updateTimeout = setTimeout(() => {
      var form = this.form
      if(form) form.send()
      this.updateTimeout = null
    }, this.updateInterval)
  }

  change(callback) {
    var value = this.value
    setTimeout(() => {
      if(value !== this.value) callback.call(this)
    })

    return this
  }

  watch(callback) {
    var change = () => this.change(callback)
    this.watchers.push({callback, change});
    ['keydown', 'paste', 'change'].forEach(event => this.element.addEventListener('keydown', change))
  }

  unwatch(callback) {
    var watcher = this.watchers.find(watcher => callback === watcher.callback)
    if(!watcher) return;
    ['keydown', 'paste', 'change'].forEach(event => this.element.removeEventListener('keydown', watcher.callback))
    this.watchers.splice(this.watchers.indexOf(watcher), 1)
  }

  resize() {
    this.element.style.height = this.constructor.minHeight + 'px'
    if(this.element.scrollHeight > this.constructor.minHeight) this.element.style.height = this.element.scrollHeight + 9 + 'px'
  }

  static for(element) {
    return this.all.find(input => input.element === element) || new this(element)
  }

  static init(scope) {
    return Application.initializing(this, {scope: scope, collect: true})
  }
}
