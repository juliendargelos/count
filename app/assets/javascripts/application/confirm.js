Application.Confirm = class Confirm {
  constructor(element) {
    this.element = element

    var options;

    try {
      options = JSON.parse(this.element.getAttribute('data-confirm'))
    }
    catch(e) {
      options = {}
    }

    this.confirmed = false
    this.popin = new Application.Popin({
      center: true,
      content: options.content || 'Please confirm this action',
      actions: [
        Application.Button.base('Cancel').element,
        Application.Button[Application.Button.type(options.type)](options.label || 'Confirm', () => {
          this.confirmed = true
          this.element.click()
        }).element
      ]
    })

    this.init()

    this.constructor.all.push(this)
  }

  init() {
    this.element.addEventListener('click', event => {
      if(!this.confirmed) {
        event.preventDefault()
        event.stopPropagation()
        this.popin.open()
      }
    })
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
      forData: 'confirm'
    })
  }
}
