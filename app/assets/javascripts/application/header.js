Application.Header = class Header {
  static get height() {
    return this.element.offsetHeight
  }

  static init(scope) {
    return Application.initializing(this, {
      scope: scope,
      init: scope => {
        if(scope === document) this.element = scope.querySelector('.header')
      }
    })
  }
}
