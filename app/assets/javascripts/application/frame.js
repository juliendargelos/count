Application.Frame = class Frame {
  static load(origin) {
    var frame = document.querySelector(origin.getAttribute('data-frame'))
    if(!frame) return false

    frame.className = frame.className.replace(/\banimation(?:--[^\s]+)\b/g, '')
    this.fade(frame, origin)

    return true
  }

  static fade(frame, origin) {
    var frameRequest
    var duration = 200
    var time

    var fade = () => {
      var t = Date.now() - time
      var progress = Math.min(1, t/duration)

      frame.style.opacity = 1 - progress

      if(progress == 1) {
        cancelAnimationFrame(frameRequest)
        this.requestFor(origin).send().then(response => {
          frame.innerHTML = response.text
          frame.style.opacity = null
          frame.style.transition = frame.style.opacity = null
          Application.init(frame)
        })
      }
      else frameRequest = requestAnimationFrame(fade)
    }

    time = Date.now()
    fade()
  }

  static requestFor(origin) {
    var methodInput = origin.querySelector('input[name="_method"]') || document.querySelector('input[form="' + origin.id + '"][name="_method"]')
    var request = new Request(
      origin.action || origin.href,
      (methodInput ? methodInput.value : false) || origin.getAttribute('method') || origin.getAttribute('data-method')
    )

    if(origin instanceof HTMLFormElement) request.data.form = origin
    request.url.parameters.frame = true

    return request
  }

  static init(scope) {
    return Application.initializing(this, {
      scope: scope,
      init: scope => {
        Array.prototype.slice.call(scope.querySelectorAll('a[data-frame], form[data-frame]')).forEach(element => {
          element.addEventListener({'A': 'click', 'FORM': 'submit'}[element.tagName], event => {
            if(this.load(element)) event.preventDefault()
          })
        })

        Array.prototype.slice.call(scope.querySelectorAll('[data-frame-src]')).forEach(frame => {
          var delay = parseFloat(frame.getAttribute('data-frame-delay'), 10)
          if(isNaN(delay)) delay = 0

          setTimeout(() => {
            var request = new Request(frame.getAttribute('data-frame-src'), frame.getAttribute('data-frame-method'))
            request.url.parameters.frame = true
            request.send().then(response => {
              frame.innerHTML = response.text
              Application.init(frame)
              if(typeof frame.onloadFrame === 'function') frame.onloadFrame(frame)
            })
          }, delay)
        })
      }
    })
  }
}
