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
