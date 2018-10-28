//= require turbolinks
//= require three/build/three

//= require open-url-js/dist/open-url.js
//= require pathname-js/dist/pathname.js
//= require parameters-js/dist/parameters.js
//= require open-request-js/dist/open-request.js
//= require open-request-js/dist/http-response.js
//= require open-request-js/dist/status.js

//= require_self
//= require_tree ./application

class Application {
  static get scroll() {
    return document.body.scrollTop || document.documentElement.scrollTop
  }

  static visit(url) {
    this.visiting = true
    var scope = this.main || document.body

    scope.style.transition = 'none'
    scope.style.opacity = 1
    scope.style.animation = 'none'

    var frameRequest;
    var time;
    var duration = 200
    var fade = () => {
      var t = Date.now() - time
      var progress = t/duration
      if(progress > 1) progress = 1

      scope.style.opacity = 1 - progress

      if(progress == 1) {
        cancelAnimationFrame(frameRequest)
        this.NotificationList.items.forEach(item => item.parentNode.removeChild(item))
        Turbolinks.visit(url)
      }
      else frameRequest = requestAnimationFrame(fade)
    }

    time = Date.now()
    fade()
  }

  static reload() {
    this.visit(window.location.href)
  }

  static minimize() {
    if(this.main) this.main.classList.add('container--minimized')
  }

  static unminimize() {
    if(this.main) this.main.classList.remove('container--minimized')
  }

  static listenToVisit() {
    window.addEventListener('turbolinks:before-visit', event => {
      if(!this.visiting) {
        this.rendering = false
        event.preventDefault()
        this.visit(event.data.url)
      }
      else this.visiting = false
    })
  }

  static initializing(subject, options = {}) {
    var result
    options = this.initializationOptions(subject, options)

    if(typeof options.once === 'function' && !subject.initialized) {
      subject.initialized = true
      options.once.call(subject, options.scope)
    }
    if(options.collect && !subject.initialized) subject.all = []
    if(typeof options.init === 'function') result = options.init.call(subject, options.scope)
    this.instanciate(subject, options.instanciate, options.scope)

    return result
  }

  static initializationOptions(subject, {scope, init, once = null, instanciate = null, method = null, collect = false, forData = null}) {
    if(!scope) scope = document
    var options = {scope, init, once, instanciate, method, collect}

    if(typeof forData === 'string') {
      options.instanciate = { data: forData, by: subject.for }
      options.collect = true
    }

    return options
  }

  static instanciate(subject, options, scope) {
    if(typeof options === 'string') options = { selector: options, by: e => new subject(e) }
    if(typeof options === 'object' && options !== null) {
      if(typeof options.data === 'string') options.selector = `[data-${options.data}]`

      return Array.prototype.slice
        .call(scope.querySelectorAll(options.selector))
        .map(element => options.by.call(subject, element))
    }
  }

  static init(scope) {
    this.initializing(this, {
      scope: scope,
      init: scope => {
        this.main = document.querySelector('main.container')
        this.Decoration.init(scope)
        this.Header.init(scope)
        this.Nav.init(scope)
        this.NotificationList.init(scope)
        this.Popin.init(scope)
        this.Frame.init(scope)
        this.Form.init(scope)
        this.Toggler.init(scope)
        this.Focuser.init(scope)
        this.Confirm.init(scope)
        this.Method.init(scope)
      },
      once: () => {
        this.visiting = false
        this.listenToVisit()
      }
    })
  }
}
