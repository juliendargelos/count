Application.Form.Association = class Association {
  constructor(element) {
    this.element = element
    this.input = Application.Form.Input.for(this.element.querySelector('.form__association-input'))
    this.key = this.element.querySelector('.form__association-key')
    this.list = this.element.querySelector('.form__association-list')
    this.items = Array.prototype.slice.call(this.list.querySelectorAll('.form__association-item'))
    this.newItem = this.list.querySelector('.form__association-item--new')
    var currentValue = this.key.value
    this.filled = false
    this.popin = new Application.Popin.Frame({
      src: this.path,
      onload: frame => {
        var form = Application.Form.for(frame.querySelector('form'))
        form.element.action += '.json'

        form.element.addEventListener('submit', event => {
          event.preventDefault()
          form.send().then(response => {
            var json = response.json
            if(json.error) Application.NotificationList.error(json.error)
            else {
              var item = document.createElement('li')
              item.className = 'form__association-item'
              item.setAttribute('data-value', json.id)
              item.textContent = json[this.attribute]
              item.search = this.constructor.normalize(item.textContent)
              item.addEventListener('mousedown', () => { this.select(item) })
              this.items.push(item)
              this.list.insertBefore(item, this.list.lastChild)
              this.selected = item
              this.select()
              this.popin.close()
            }
          })
        })

        var input = form.element.querySelector(`#${this.model}_${this.attribute === 'to_s' ? 'name' : this.attribute}`)
        if(!input) input = form.element.querySelector('input:not([type="hidden"]), textarea')
        if(input) {
          input.value = this.input.value
          input.focus()
        }
      }
    })
    this.init()
    this.key.value = currentValue
    this.updateNewItem()
    this.constructor.all.push(this)
  }

  get terms() {
    return this.constructor.normalize(this.input.value)
  }

  get visibleItems() {
    return this.items.filter(item => !item.classList.contains('form__association-item--hidden'))
  }

  get selected() {
    return this.visibleItems.find(item => item.classList.contains('form__association-item--selected'))
  }

  set selected(v) {
    this.items.forEach(item => item.classList.remove('form__association-item--selected'))
    if(v) v.classList.add('form__association-item--selected')
  }

  get index() {
    return this.visibleItems.indexOf(this.selected)
  }

  set index(v) {
    var visibleItems = this.visibleItems
    if(v < 0) v = visibleItems.length - 1
    this.selected = visibleItems[v%visibleItems.length]
  }

  get filled() {
    return this.element.classList.contains('form__association--filled')
  }

  set filled(v) {
    if(!v) this.key.value = null
    this.element.classList[v ? 'add' : 'remove']('form__association--filled')
  }

  get path() {
    return this.element.getAttribute('data-path')
  }

  get attribute() {
    return this.element.getAttribute('data-attribute')
  }

  get model() {
    return this.element.getAttribute('data-model')
  }

  init() {
    this.input.element.addEventListener('keydown', event => {
      if(['ArrowDown', 'ArrowUp', 'Enter', 'Escape'].includes(event.key)) {
        event.preventDefault()
        event.stopPropagation()
      }

      this.keydown(event.key)
    })

    this.input.element.addEventListener('focus', () => this.filter())

    this.input.watch(() => {
      this.filled = false
      this.updateNewItem()
      this.filter()
    })

    this.items.forEach(item => {
      item.search = this.constructor.normalize(item.textContent)
      item.addEventListener('mousedown', () => { this.select(item) })
    })
  }

  keydown(key) {
    switch(key) {
      case 'ArrowDown':
        this.down()
        break;
      case 'ArrowUp':
        this.up()
        break;
      case 'Enter':
        if(!this.filled) this.select()
        break;
      case 'Escape':
        this.input.element.blur()
        break;
    }
  }

  filter() {
    var terms = this.terms

    this.items.forEach(item => {
      item.classList[!terms || (item !== this.newItem && item.search.indexOf(terms) == -1) ? 'add' : 'remove']('form__association-item--hidden')
    })

    this.selected = this.visibleItems[0]
  }

  up() {
    this.index--
  }

  down() {
    this.index++
  }

  select() {
    var selected = this.selected

    if(selected) {
      if(selected === this.newItem) this.popin.open()
      else {
        this.input.value = selected.textContent
        this.key.value = selected.getAttribute('data-value')
        this.filled = true
        this.selected = null
      }
    }
  }

  updateNewItem() {
    this.newItem.textContent = this.input.value
  }

  static normalize(string) {
    return string.normalize('NFD').replace(/[\u0300-\u036f]/g, '').trim().toLowerCase()
  }

  static for(element) {
    return this.all.find(association => association.element === element) || new this(element)
  }

  static init(scope) {
    Application.initializing(this, {
      scope: scope,
      instanciate: {
        selector: '.form__association',
        by: element => this.for(element)
      },
      collect: true
    })
  }
}
