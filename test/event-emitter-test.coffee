jest.autoMockOff()

KDEventEmitter = require '../src/event-emitter'

describe 'KDEventEmitter', ->

  describe '.registerStaticEmitter', ->

    it 'creates events holder', ->

      KDEventEmitter.registerStaticEmitter()
      expect(KDEventEmitter._e).toBeDefined()


  describe '.emit', ->

    describe "when event holder isn't defined", ->

      # becuase of the `registerStaticEmitter`
      # test it's set to an empty object.
      # so set it to null to be able to test.
      beforeEach -> KDEventEmitter._e = null

      it 'throws an error', ->

        expect(-> KDEventEmitter.emit()).toThrow()

    describe 'when event holder is defined', ->

      beforeEach -> KDEventEmitter.registerStaticEmitter()

      it 'registers an event with the name', ->

        KDEventEmitter.emit 'anEvent'
        expect(KDEventEmitter._e['anEvent']).toBeDefined()


      it 'calls all of the listeners', ->

        array = []
        KDEventEmitter._e['anEvent'] = []
        KDEventEmitter._e['anEvent'].push(-> array.push( 1 ))
        KDEventEmitter._e['anEvent'].push(-> array.push( 2 ))

        KDEventEmitter.emit 'anEvent'

        expect(array).toEqual [1, 2]


      it 'returns itself for chaining', ->

        expect(KDEventEmitter.emit 'anEvent').toBe KDEventEmitter


  describe '.on', ->

    describe 'when listener is not a function', ->

      it 'throws an error', ->

        expect(-> KDEventEmitter.on()).toThrow         "listener is not a function"
        expect(-> KDEventEmitter.on('a', 'b')).toThrow "listener is not a function"
        expect(-> KDEventEmitter.on('a', 1)).toThrow   "listener is not a function"
        expect(-> KDEventEmitter.on('a', {})).toThrow  "listener is not a function"
        expect(-> KDEventEmitter.on('a', [])).toThrow  "listener is not a function"
        expect(-> KDEventEmitter.on('a', yes)).toThrow "listener is not a function"

    describe "when event holder isn't defined", ->

      beforeEach -> KDEventEmitter._e = null

      it 'throws an error', ->

        expect(-> KDEventEmitter.on 'a', ->).toThrow()

    describe 'happy path', ->

      beforeEach -> KDEventEmitter.registerStaticEmitter()

      it 'emits an event with listener', ->

        KDEventEmitter.on 'foo', -> yes

        expect(KDEventEmitter._e['ListenerAdded']).toBeDefined()


      it 'registers an event', ->

        count = 0
        KDEventEmitter.on 'FooHappened', -> count++

        KDEventEmitter.emit 'FooHappened'
        expect(count).toBe 1

        KDEventEmitter.emit 'FooHappened'
        expect(count).toBe 2

      it 'registers multiple events', ->

        count = 0
        KDEventEmitter.on ['FooHappened', 'BarHappened'], -> count++

        KDEventEmitter.emit 'FooHappened'
        expect(count).toBe 1

        KDEventEmitter.emit 'BarHappened'
        expect(count).toBe 2


      it 'returns itself for chaining', ->

        expect(KDEventEmitter.on 'anEvent', ->).toBe KDEventEmitter


  describe '.off', ->

    beforeEach -> KDEventEmitter.registerStaticEmitter()

    it 'emits an event after removing the listener', ->

      count = 0
      KDEventEmitter.on 'ListenerRemoved', -> count++

      listener = -> yes
      KDEventEmitter.on 'FooHappened', listener
      KDEventEmitter.off 'FooHappened', listener

      expect(count).toBe 1

    it 'unregisters an event', ->

      listener = -> yes
      KDEventEmitter.on 'FooHappened', listener
      KDEventEmitter.off 'FooHappened', listener

      expect(KDEventEmitter._e['FooHappened'].length).toBe 0


    it 'unregisters multiple events', ->

      listener = -> yes
      KDEventEmitter.on  ['FooHappened', 'BarHappened'], listener
      KDEventEmitter.off ['FooHappened', 'BarHappened'], listener

      expect(KDEventEmitter._e['FooHappened'].length).toBe 0
      expect(KDEventEmitter._e['BarHappened'].length).toBe 0


    it 'returns itself for chaining', ->

      listener = -> yes
      KDEventEmitter.on 'FooHappened', listener
      offFn = KDEventEmitter.off 'FooHappened', listener

      expect(offFn).toBe KDEventEmitter


  describe '#constructor', ->

    it 'creates events holder', ->

      emitter = new KDEventEmitter
      expect(emitter._e).toBeDefined()


  describe '#emit', ->

    it 'creates an event holder', ->

      emitter = new KDEventEmitter
      emitter.emit 'FooHappened'

      expect(emitter._e['FooHappened']).toBeDefined()


    it 'calls listeners', ->

      array = []
      emitter = new KDEventEmitter
      emitter._e = {}
      emitter._e['FooHappened'] = []
      emitter._e['FooHappened'].push(-> array.push( 1 ))
      emitter._e['FooHappened'].push(-> array.push( 2 ))

      emitter.emit 'FooHappened'

      expect(array).toEqual [1, 2]


    it 'returns itself for chaining', ->

      emitter = new KDEventEmitter
      emitResult = emitter.emit 'FooHappened'

      expect(emitResult).toBe emitter


  describe '#on', ->

    describe 'when listener is not a function', ->

      it 'throws an error', ->

        emitter = new KDEventEmitter
        expect(-> emitter.on()).toThrow()
        expect(-> emitter.on('a', 'b')).toThrow()
        expect(-> emitter.on('a', 1)).toThrow()
        expect(-> emitter.on('a', {})).toThrow()
        expect(-> emitter.on('a', [])).toThrow()
        expect(-> emitter.on('a', yes)).toThrow()


    it 'emits an event with listener', ->

      emitter = new KDEventEmitter
      emitter.on 'FooHappened', ->

      expect(emitter._e['ListenerAdded']).toBeDefined()


    it 'registers an event', ->

      array    = []
      emitter  = new KDEventEmitter

      emitter.on 'FooHappened', (foo) -> array.push foo

      emitter.emit 'FooHappened', 1
      emitter.emit 'FooHappened', 2

      expect(array).toEqual [1, 2]


    it 'registers multiple events', ->

      emitter = new KDEventEmitter

      count = 0
      emitter.on ['FooHappened', 'BarHappened'], -> count++

      emitter.emit 'FooHappened'
      expect(count).toBe 1

      emitter.emit 'BarHappened'
      expect(count).toBe 2


    it 'returns itself for chaining', ->

      emitter = new KDEventEmitter

      expect(emitter.on 'FooHappened', ->).toBe emitter


  describe '#off', ->

    it 'emits an event', ->

      count = 0
      emitter = new KDEventEmitter
      emitter.on 'ListenerRemoved', -> count++

      listener = ->
      emitter.on 'FooHappened', listener
      emitter.off 'FooHappened', listener

      expect(count).toBe 1


    it 'unregisters an event', ->

      emitter = new KDEventEmitter

      listener = ->
      emitter.on 'FooHappened', listener
      emitter.off 'FooHappened', listener

      expect(emitter._e['FooHappened'].length).toBe 0


    it 'unregisters multiple events', ->

      listener = -> yes
      emitter  = new KDEventEmitter

      emitter.on  ['FooHappened', 'BarHappened'], listener
      emitter.off ['FooHappened', 'BarHappened'], listener

      expect(emitter._e['FooHappened'].length).toBe 0
      expect(emitter._e['BarHappened'].length).toBe 0


    it 'returns itself for chaining', ->

      emitter  = new KDEventEmitter

      listener = ->
      emitter.on 'FooHappened', listener
      expect(emitter.off 'FooHappened', listener).toBe emitter


  describe '#once', ->

    it 'registers an event to be called only once', ->

      emitter  = new KDEventEmitter

      count = 0
      emitter.once 'FooHappened', -> count++

      emitter.emit 'FooHappened'
      expect(count).toBe 1

      emitter.emit 'FooHappened'
      expect(count).toBe 1


    it 'returns itself for chaining', ->

      emitter = new KDEventEmitter
      expect(emitter.once 'FooHappened', ->).toBe emitter


  describe '#forwardEvent', ->

    emitter = new KDEventEmitter
    otherEmitter = new KDEventEmitter

    it 'forwards an event from given event emitter', ->

      count = 0
      emitter.on 'FooHappened', (number) -> count += number

      # start listening 'FooHappened' event on
      # other emitter to forward.
      emitter.forwardEvent otherEmitter, 'FooHappened'

      # emit event on otherEmitter
      otherEmitter.emit 'FooHappened', 7

      # expect emitter to forward event so that count would get updated.
      expect(count).toBe 7


    it 'forwards an event with extra prefix', ->

      count = 0
      emitter.on 'PrefixFooHappened', (number) -> count += number

      emitter.forwardEvent otherEmitter, 'FooHappened', 'Prefix'

      otherEmitter.emit 'FooHappened', 5

      expect(count).toBe 5


  describe '#forwardEvents', ->

    beforeEach ->

      @emitter = new KDEventEmitter
      @otherEmitter = new KDEventEmitter
      @events = ['FooHappened', 'BarHappened']

    it 'forwards list of events from given event emitter', ->

      result = {}

      @emitter.on 'FooHappened', (value) -> result.foo = value
      @emitter.on 'BarHappened', (value) -> result.bar = value

      @emitter.forwardEvents @otherEmitter, @events

      @otherEmitter.emit 'FooHappened', 'baz'
      @otherEmitter.emit 'BarHappened', 'qux'

      expect(result.foo).toBe 'baz'
      expect(result.bar).toBe 'qux'

    it 'forwards list of events with extra prefix', ->

      result = {}

      @emitter.on 'PrefixFooHappened', (value) -> result.foo = value
      @emitter.on 'PrefixBarHappened', (value) -> result.bar = value

      # notice prefix as 3rd arg.
      @emitter.forwardEvents @otherEmitter, @events, 'Prefix'

      @otherEmitter.emit 'FooHappened', 'baz'
      @otherEmitter.emit 'BarHappened', 'qux'

      expect(result.foo).toBe 'baz'
      expect(result.bar).toBe 'qux'

