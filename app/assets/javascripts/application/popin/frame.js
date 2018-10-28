Application.Popin.Frame = class Frame extends Application.Popin {
  constructor(...args) {
    super(...args)
    this.elements.box.classList.remove('box')
  }

  get src() {
    return this.elements.box.getAttribute('data-frame-src')
  }

  set src(v) {
    this.elements.box.setAttribute('data-frame-src', v)
  }

  get onload() {
    return this.elements.box.onloadFrame
  }

  set onload(v) {
    this.elements.box.onloadFrame = v
  }

  set({src = null, onload = null, actions = null, center = false} = {}) {
    this.src = src
    this.onload = onload
    this.actions = actions
    this.center = center
  }

  open(...args) {
    this.elements.box.innerHTML = ''
    super.open(...args)
  }
}
