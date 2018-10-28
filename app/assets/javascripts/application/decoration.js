Application.Decoration = class Decoration {
  constructor(element) {
    this.renderer = new THREE.WebGLRenderer({antialias: true, canvas: element, alpha: true})
    this.camera   = new THREE.PerspectiveCamera(70, this.width/this.height, 0.01, 10)
    this.scene    = new THREE.Scene()
    this.geometry = new THREE.BufferGeometry()
    this.uniforms = {
      size:    {type: 'f',    value: 3},
      origin:  {type: 'vec2', value: new THREE.Vector2(0, 0)},
      time:    {type: 'f',    value: 0},
      speed:   {type: 'f',    value: 1},
      length:  {type: 'f',    value: 300},
      spacing: {type: 'vec2', value: new THREE.Vector2(0.02, 0.01)}
    }
    this.material = new THREE.ShaderMaterial({
      uniforms: this.uniforms,
      vertexShader: this.constructor.shaders.vertex,
      fragmentShader: this.constructor.shaders.fragment,
      transparent: true
    });
    this.mesh     = new THREE.Points(this.geometry, this.material)
    this.mouse    = {
      x: window.innerWidth/2,
      y: window.innerHeight/2,
      previous: {
        x: window.innerWidth/2,
        y: window.innerHeight/2
      },
      xSpeed: 1,
      xSign: 1
    }
    this.frame    = null
    this.animate  = () => {
      this.update().render()
      this.frame = window.requestAnimationFrame(this.animate)
    }

    this.scene.add(this.mesh)
    window.addEventListener('resize', () => this.resize())
    window.addEventListener('mousemove', event => {
      this.mouse.x = event.clientX
      this.mouse.y = event.clientY
    })
  }

  get element() {
    return this.renderer.domElement
  }

  get width() {
    return this.element.parentNode.offsetWidth
  }

  get height() {
    return this.element.parentNode.offsetHeight
  }

  get ratio() {
    return this.width/this.height
  }

  get playing() {
    return this.frame !== null
  }

  get amount() {
    return Math.pow(this.uniforms.length.value, 2)
  }

  setCamera() {
    this.camera.position.set(0.05860505518864125, -1.6671126485960273, -1.1033135838905577*1000/Math.max(1000, this.width))
    this.camera.rotation.set(2.155429816694763, 0.029306722593300912, -3.097345278648779)

    return this
  }

  each(callback) {
    for(var index = this.amount - 1; index >= 0; index--) callback.call(this, index)
  }

  init() {
    this.renderer.setClearColor(0x000000, 0)
    this.resize()
    this.geometry.addAttribute('position', new THREE.BufferAttribute(new Float32Array((new Array(this.amount*3)).fill(0).map((v, index) => Math.floor(index/3))), 3));
    ['x', 'y'].forEach(c => {
      this.uniforms.origin.value[c] = -this.uniforms.length.value/2*this.uniforms.spacing.value[c]
    })
    this.setCamera()

    return this
  }

  play() {
    this.animate()
    return this
  }

  pause() {
    window.cancelAnimationFrame(this.frame)
    this.frame = null

    return this
  }

  update() {
    if(this.mouse.x !== this.mouse.previous.x) this.mouse.xSign = this.mouse.x > this.mouse.previous.x ? 1 : -1
    this.mouse.xSpeed += (this.mouse.xSign*(1 + Math.pow((this.mouse.x - this.mouse.previous.x)*0.05, 2)) - this.mouse.xSpeed)*0.05;
    var mouseDelta = Math.sqrt(Math.pow(this.mouse.x - this.mouse.previous.x, 2) + Math.pow(this.mouse.y - this.mouse.previous.y, 2))
    this.mouse.previous.x = this.mouse.x
    this.mouse.previous.y = this.mouse.y

    this.uniforms.time.value += 1
    this.uniforms.speed.value += (1 + mouseDelta*0.01 - this.uniforms.speed.value)*0.05
    this.mesh.rotation.z += 0.005*this.mouse.xSpeed

    return this
  }

  render() {
    this.renderer.render(this.scene, this.camera)

    return this
  }

  resize() {
    this.camera.aspect = this.ratio;
    this.camera.updateProjectionMatrix()
    this.setCamera()
    this.renderer.setSize(this.width, this.height)

    return this
  }

  static init(scope) {
    return Application.initializing(this, {
      scope: scope,
      instanciate: {selector: 'canvas.decoration', by: element => new this(element).init().play()}
    })
  }
}
