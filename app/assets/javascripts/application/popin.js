Application.Popin = class Popin {
  constructor(options = {}) {
    this.element = document.importNode(this.constructor.template, true)
    this.elements = {
      title: this.element.querySelector('.popin__title'),
      content: this.element.querySelector('.popin__content'),
      actions: this.element.querySelector('.popin__actions'),
    }

    this.parents = {
      title: this.elements.title.parentNode,
      content: this.elements.content.parentNode,
      actions: this.elements.actions.parentNode
    }

    this.set(options)

    this.init()
  }

  get title() {
    return this.elements.title.textContent || null
  }

  set title(v) {
    this.update('title', v)
  }

  get content() {
    return this.elements.content.textContent || null
  }

  set content(v) {
    this.update('content', v)
  }

  get actions() {
    return this._actions
  }

  set actions(v) {
    this._actions = Array.isArray(v) ? v : []
    this.elements.actions.innerHTML = ''
    this.actions.forEach(action => {
      action.addEventListener('click', () => this.close())
      this.elements.actions.appendChild(action)
    })

    this.update('actions', this.actions.length, false)
  }

  get opened() {
    return this.element.classList.contains('popin--open')
  }

  get closed() {
    return !this.opened
  }

  get center() {
    return this.element.classList.contains('popin--center')
  }

  set center(v) {
    this.element.classList[v ? 'add' : 'remove']('popin--center')
  }

  update(element, value, set) {
    if(set !== false) {
      value = this.constructor.trim(value)
      this.elements[element].textContent = value
    }

    if(!value && this.elements[element].parentNode) this.elements[element].parentNode.removeChild(this.elements[element])
    else if(value && !this.elements[element].parentNode) this.parents[element].appendChild(this.elements[element])
  }

  init() {
    this.element.addEventListener('click', event => {
      if(event.target == this.element) this.close()
    })

    window.addEventListener('keydown', event => {
      if(this.opened) {
        switch(event.key) {
          case 'Escape':
            event.preventDefault()
            this.close()
            break
          case 'Enter':
            event.preventDefault()
            if(this.actions.length) this.actions[this.actions.length - 1].click()
            else this.close
            break
        }
      }
    })
  }

  set({title = null, content = null, actions = null, center = false} = {}) {
    this.title = title
    this.content = content
    this.actions = actions
    this.center = center
  }

  open(options) {
    if(typeof options === 'object') this.set(options)
    if(this.element.parentNode) document.body.appendChild(this.element)
    this.element.classList.add('popin--open')
    if(!this.element.parentNode) document.body.appendChild(this.element)
    var main = document.querySelector('main.container')
    Application.minimize()
    Application.init(this.element)

    return this
  }

  close() {
    this.element.classList.remove('popin--open')
    if(!document.querySelector('.popin.popin--open')) Application.unminimize()

    setTimeout(() => {
      if(this.element.parentNode) this.element.parentNode.removeChild(this.element)
    }, 300)

    return this
  }

  static trim(value) {
    return value ? (value + '').trim() || null : null
  }

  static init(scope) {
    return Application.initializing(this, {
      scope: scope,
      once: () => {
        this.template = document.getElementById('popin').content.querySelector('.popin')
      }
    })
  }
}
