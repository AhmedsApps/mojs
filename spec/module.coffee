Module = mojs.Module
h      = mojs.h

oldFun = Module::_declareDefaults
describe 'module class ->', ->
  it 'set the _defaults up', ->
    defaults = {
        stroke:           'transparent',
        strokeOpacity:    1,
        strokeLinecap:    '',
        strokeWidth:      2,
        strokeDasharray:  0,
        strokeDashoffset: 0,
        fill:             'deeppink',
        fillOpacity:      1,
        left:             0,
        top:              0,
        x:                0,
        y:                0,
        rx:               0,
        ry:               0,
        angle:            0,
        scale:            1,
        opacity:          1,
        points:           3,
        radius:           { 0: 50 },
        radiusX:          null,
        radiusY:          null,
        isShowStart:      false,
        isShowEnd:        false,
        size:             null,
        sizeGap:          0,
        callbacksContext: null
      }

    Module::_declareDefaults = -> this._defaults = defaults

  describe 'init ->', ->
    it 'should save options to _o', ->
      options = {}
      md = new Module options
      expect(md._o).toBe options
    it 'should fallback to empty object for _o', ->
      md = new Module

      expect(Object.keys(md._o).length).toBe 0
      expect(typeof md._o).toBe 'object'
      # not null
      expect(md._o).toBe md._o
    it 'should call _declareDefaults method', ->
      spyOn(Module.prototype, '_declareDefaults').and.callThrough()
      md = new Module
      expect(Module.prototype._declareDefaults).toHaveBeenCalled()
    it 'should call _extendDefaults method', ->
      spyOn(Module.prototype, '_extendDefaults').and.callThrough()
      md = new Module
      expect(Module.prototype._extendDefaults).toHaveBeenCalled()
    it 'should call _vars method', ->
      spyOn(Module.prototype, '_vars').and.callThrough()
      md = new Module
      expect(Module.prototype._vars).toHaveBeenCalled()
    it 'should call _render method', ->
      spyOn(Module.prototype, '_render').and.callThrough()
      md = new Module
      expect(Module.prototype._render).toHaveBeenCalled()

  describe '_declareDefaults method ->', ->
    it 'should create _defaults object', ->
      spyOn(Module.prototype, '_declareDefaults').and.callThrough()
      md = new Module
      expect(Module.prototype._declareDefaults).toHaveBeenCalled()
      expect(typeof md._defaults).toBe 'object'
      # not null
      expect(md._defaults).toBe md._defaults

  describe '_vars method ->', ->
    it 'should create _index property', ->
      index = 5
      md = new Module index: index
      expect(md._index).toBe index
    it 'should fallback to 0 for _index property', ->
      md = new Module
      expect(md._index).toBe 0
    it 'should set _progress proprty to 0', ->
      md = new Module
      expect(md._progress).toBe 0
    it 'should create _strokeDasharrayBuffer array', ->
      md = new Module
      expect(md._strokeDasharrayBuffer.length).toBe 0
      expect(h.isArray(md._strokeDasharrayBuffer)).toBe true
  describe '_assignProp method ->', ->
    it 'should set property on _props object', ->
      value = 2
      md = new Module
      md._assignProp 'a', value
      expect(md._props.a).toBe value
  describe '_setProp method ->', ->
    it 'should set new tween options', ->
      t = new Module duration: 100, delay: 0
      t._setProp duration: 1000, delay: 200
      expect(t._props.duration).toBe 1000
      expect(t._props.delay).toBe    200
    it 'should work with arguments', ->
      t = new Module duration: 100
      t._setProp 'duration', 1000
      expect(t._props.duration).toBe 1000

  describe '_show method ->', ->
    it 'should set display: block to el', ->
      md = new Module
      md.el = document.createElement 'div'
      md._show()
      expect(md.el.style.display).toBe 'block'
      expect(md._isShown).toBe true
    it 'should return if isShow is already true', ->
      md = new Module
      md.el = document.createElement 'div'
      md._show()
      md.el.style.display = 'inline'
      md._show()
      expect(md.el.style.display).toBe 'inline'
    it 'not to throw', ->
      byte = new Module radius:  {'25': 75}
      expect(-> byte._show()).not.toThrow()
  describe '_hide method ->', ->
    it 'should set display: block to el', ->
      md = new Module
      md.el = document.createElement 'div'
      md._hide()
      expect(md.el.style.display).toBe 'none'
      expect(md._isShown).toBe false
    it 'not to throw', ->
      byte = new Module radius:  {'25': 75}
      expect(-> byte._hide()).not.toThrow()

  describe '_parseOptionString method ->', ->
    tr = new Module
    it 'should parse stagger values', ->
      string = 'stagger(200)'
      spyOn(h, 'parseStagger').and.callThrough()
      result = tr._parseOptionString string
      expect(h.parseStagger).toHaveBeenCalledWith string, 0
      expect(result).toBe h.parseStagger(string, 0)

    it 'should parse rand values', ->
      string = 'rand(0,1)'
      spyOn(h, 'parseRand').and.callThrough()
      result = tr._parseOptionString string
      expect(h.parseRand).toHaveBeenCalledWith string

  describe '_parsePositionOption method ->', ->
    tr = new Module
    it 'should parse position option', ->
      tr._props.x = '100%'
      key = 'x'
      spyOn(h, 'parseUnit').and.callThrough()
      result = tr._parsePositionOption key
      expect(h.parseUnit).toHaveBeenCalledWith tr._props[key]
      expect(result).toBe h.parseUnit(tr._props[key]).string
    it 'should leave the value unattended if not pos property', ->
      tr._props.x = '100%'
      key = 'fill'
      spyOn(h, 'parseUnit').and.callThrough()
      result = tr._parsePositionOption key
      expect(h.parseUnit).not.toHaveBeenCalledWith()
      expect(result).toBe tr._props[key]

  describe '_parseStrokeDashOption method ->', ->
    tr = new Module
    it 'should parse strokeDash option', ->
      tr._props.strokeDasharray = 200
      key = 'strokeDasharray'
      spyOn(h, 'parseUnit').and.callThrough()
      result = tr._parseStrokeDashOption key
      expect(h.parseUnit).toHaveBeenCalledWith tr._props[key]
      expect(result[0].unit).toBe h.parseUnit(tr._props[key]).unit
      expect(result[0].isStrict).toBe h.parseUnit(tr._props[key]).isStrict
      expect(result[0].value).toBe h.parseUnit(tr._props[key]).value
      expect(result[0].string).toBe h.parseUnit(tr._props[key]).string
      expect(result[1]).not.toBeDefined()
    it 'should parse strokeDash option string', ->
      tr._props.strokeDasharray = '200 100'
      key = 'strokeDasharray'
      spyOn(h, 'parseUnit').and.callThrough()
      result = tr._parseStrokeDashOption key
      expect(h.parseUnit).toHaveBeenCalledWith '200'
      expect(h.parseUnit).toHaveBeenCalledWith '100'
      expect(result[0].unit).toBe h.parseUnit(200).unit
      expect(result[0].isStrict).toBe h.parseUnit(200).isStrict
      expect(result[0].value).toBe h.parseUnit(200).value
      expect(result[0].string).toBe h.parseUnit(200).string
      expect(result[1].unit).toBe h.parseUnit(100).unit
      expect(result[1].isStrict).toBe h.parseUnit(100).isStrict
      expect(result[1].value).toBe h.parseUnit(100).value
      expect(result[1].string).toBe h.parseUnit(100).string
      expect(result[2]).not.toBeDefined()
    it 'should parse strokeDashoffset option', ->
      tr._props.strokeDashoffset = '100%'
      key = 'strokeDashoffset'
      spyOn(h, 'parseUnit').and.callThrough()
      result = tr._parseStrokeDashOption key
      expect(h.parseUnit).toHaveBeenCalledWith tr._props[key]
      expect(result[0].unit).toBe h.parseUnit(tr._props[key]).unit
      expect(result[0].isStrict).toBe h.parseUnit(tr._props[key]).isStrict
      expect(result[0].value).toBe h.parseUnit(tr._props[key]).value
      expect(result[0].string).toBe h.parseUnit(tr._props[key]).string
      expect(result[1]).not.toBeDefined()
    it 'should leave the value unattended if not strokeDash.. property', ->
      tr._props.x = '100%'
      key = 'fill'
      spyOn(h, 'parseUnit').and.callThrough()
      result = tr._parseStrokeDashOption key
      expect(h.parseUnit).not.toHaveBeenCalledWith()
      expect(result).toBe tr._props[key]
  describe '_isDelta method ->', ->
    it 'should detect if value is not a delta value', ->
      byte = new Module radius: 45, stroke: 'deeppink': 'pink'
      expect(byte._isDelta(45))    .toBe false
      expect(byte._isDelta('45'))  .toBe false
      expect(byte._isDelta(['45'])).toBe false
      expect(byte._isDelta({ unit: 'px', value: 20 })).toBe false
      expect(byte._isDelta({ 20: 30 })).toBe true

  describe '_parseOption method ->', ->
    it 'should parse delta value', ->
      md = new Module
      spyOn md, '_getDelta'
      name = 'radius'; delta = { 20: 30 }
      md._parseOption name, delta
      expect(md._getDelta).toHaveBeenCalledWith name, delta
    it 'should parse option string', ->
      md = new Module
      spyOn md, '_getDelta'
      spyOn(md, '_parseOptionString').and.callThrough()
      name = 'delay'; value = 'stagger(400, 200)'
      md._parseOption name, value
      expect(md._getDelta).not.toHaveBeenCalledWith name, value
      expect(md._parseOptionString).toHaveBeenCalledWith value
      expect(md._props[name]).toBe 400
    it 'should parse position option', ->
      md = new Module
      spyOn(md, '_parsePositionOption').and.callThrough()
      name = 'x'; value = '20%'
      md._parseOption name, value
      expect(md._parsePositionOption).toHaveBeenCalledWith name
      expect(md._props[name]).toBe value
    it 'should parse strokeDasharray option', ->
      md = new Module
      spyOn(md, '_parseStrokeDashOption').and.callThrough()
      name = 'strokeDasharray'; value = '200 100% 200'
      md._props[name] = value
      parsed = md._parseStrokeDashOption(name)
      md._props[name] = value
      md._parseOption name, value
      expect(md._parseStrokeDashOption).toHaveBeenCalledWith name
      expect(md._props[name]).toEqual parsed

  describe '_extendDefaults method ->', ->
    it 'should create _props object', ->
      spyOn(Module.prototype, '_extendDefaults').and.callThrough()
      md = new Module
      expect(Module.prototype._extendDefaults).toHaveBeenCalled()
      expect(typeof md._props).toBe 'object'
      expect(md._props).toBe md._props
    it 'should extend defaults object to properties', ->
      md = new Module radius: 45, radiusX: 50
      expect(md._props.radius) .toBe(45)
      expect(md._props.radiusX).toBe(50)
    it 'should extend defaults object to properties if 0', ->
      md = new Module radius: 0
      expect(md._props.radius).toBe(0)
    it 'should extend defaults object to properties if object was passed', ->
      md = new Module radius: {45: 55}
      expect(md._props.radius).toBe(45)
    it 'should ignore properties defined in skipProps object', ->
      md = new Module radius: 45
      md._skipProps = radius: 1
      md._o.radius = 50
      md._extendDefaults()
      expect(md._props.radius).not.toBe(50)
    it 'should extend defaults object to properties if array was passed', ->
      array = [50, 100]
      md = new Module radius: array
      spyOn(md, '_assignProp').and.callThrough()
      md._extendDefaults()
      expect(md._props.radius.join ', ').toBe '50, 100'
      expect(md._assignProp).toHaveBeenCalledWith 'radius', array
    it 'should extend defaults object to properties if rand was passed', ->
      md = new Module radius: 'rand(0, 10)'
      spyOn(md, '_assignProp').and.callThrough()
      md._extendDefaults()
      expect(md._props.radius).toBeDefined()
      expect(md._props.radius).toBeGreaterThan -1
      expect(md._props.radius).not.toBeGreaterThan 10
      expect(md._assignProp).toHaveBeenCalled()
    describe 'stagger values', ->
      it 'should extend defaults object to properties if stagger was passed', ->
        md = new Module radius: 'stagger(200)'
        spyOn(md, '_assignProp').and.callThrough()
        md._index = 2
        md._extendDefaults()
        expect(md._props.radius).toBe 400
        expect(md._assignProp).toHaveBeenCalledWith 'radius', 400
  describe '_setProgress method ->', ->
    it 'should set transition progress', ->
      byte = new Module radius:  {'25.50': -75.50}
      byte._setProgress .5
      expect(byte._progress).toBe .5
    it 'should set value progress', ->
      byte = new Module radius:  {'25': 75}
      byte._setProgress .5
      expect(byte._props.radius).toBe 50
    it 'should call _calcCurrentProps', ->
      byte = new Module radius:  {'25': 75}
      spyOn byte, '_calcCurrentProps'
      byte._setProgress .5
      expect(byte._calcCurrentProps).toHaveBeenCalledWith .5
    it 'should set color value progress and only int', ->
      byte = new Module stroke:  {'#000': 'rgb(255,255,255)'}
      colorDelta = byte._deltas.stroke
      byte._setProgress .5
      expect(byte._props.stroke).toBe 'rgba(127,127,127,1)'
    it 'should set color value progress for delta starting with 0', ->
      byte = new Module stroke:  {'#000': 'rgb(0,255,255)'}
      colorDelta = byte._deltas.stroke
      byte._setProgress .5
      expect(byte._props.stroke).toBe 'rgba(0,127,127,1)'

  describe '_tuneNewOptions method', ->
    it 'should rewrite options from passed object to _o and _props', ->
      md = new Module radius: 45, radiusX: 50
      md._tuneNewOptions radius: 20
      expect(md._o.radius)     .toBe(20)
      expect(md._props.radius) .toBe(20)
    it 'should extend defaults object to properties if 0', ->
      md = new Module radius: 40
      md._tuneNewOptions radius: 0
      expect(md._props.radius).toBe(0)
    it 'should call _hide method', ->
      md = new Module radius: 45
      spyOn(md, '_hide').and.callThrough()
      md._tuneNewOptions radius: 20
      expect(md._hide).toHaveBeenCalled()
    it 'should ignore properties defined in skipProps object', ->
      md = new Module radius: 45
      md._skipProps = radius: 1
      md._tuneNewOptions radius: 20
      expect(md._props.radius).toBe(45)
    it 'should extend defaults object to properties if array was passed', ->
      md = new Module radius: 50
      md._tuneNewOptions 'radius': [50, 100]
      expect(md._props.radius.join ', ').toBe '50, 100'
    it 'should extend defaults object to properties if rand was passed', ->
      md = new Module radius: 20
      md._tuneNewOptions 'radius': 'rand(0, 10)'
      expect(md._props.radius).toBeDefined()
      expect(md._props.radius).toBeGreaterThan -1
      expect(md._props.radius).not.toBeGreaterThan 10
    it 'should extend defaults object to properties if stagger was passed', ->
      md = new Module radius: 20
      md._index = 2
      md._tuneNewOptions radius: 'stagger(200)'
      expect(md._props.radius).toBe 400

  it 'clean the _defaults  up', ->
    Module::_declareDefaults = oldFun


