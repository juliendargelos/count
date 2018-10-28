Application.NotificationList = class NotificationList {
  static get top() {
    return this.element.offsetTop
  }

  static set top(v) {
    this.element.style.top = v + 'px'
  }

  static update() {
    if(Application.Header.element) {
      this.top = Math.max(0, Application.Header.height - Application.scroll) + this.margin
    }
  }

  static success(message) {
    this.notificate('success', message)
  }

  static info(message) {
    this.notificate('info', message)
  }

  static warning(message) {
    this.notificate('warning', message)
  }

  static error(message) {
    this.notificate('error', message)
  }

  static notificate(type, message) {
    var item = document.createElement('li')
    item.className = 'notification-list__item'

    var notification = document.createElement('p')
    notification.className = `notification notification--${type}`
    notification.textContent = message

    item.appendChild(notification)

    if(this.element.firstChild) {
      this.element.insertBefore(item, this.element.firstChild)
    }
    else this.element.appendChild(item)

    this.element.style.animation = 'none'
    item.style.animation = 'none'

    setTimeout(() => {
      this.element.style.animation = null
      item.style.animation = null
    }, 1)
  }

  static init(scope) {
    return Application.initializing(this, {
      scope: scope,
      init: scope => {
        if(scope === document) {
          this.element = scope.querySelector('.notification-list')
          this.items = this.element.querySelectorAll('.notification-list__item')
          this.update()
        }
      },
      once: () => {
        this.margin = 30
        window.addEventListener('scroll', () => this.update())
        window.addEventListener('resize', () => this.update())
      }
    })
  }
}
