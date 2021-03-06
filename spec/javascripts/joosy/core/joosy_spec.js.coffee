describe "Joosy", ->

  it "should properly initialize", ->
    expect(Joosy.Application.debug).toBeFalsy()
    expect(Joosy.Modules).toBeDefined()
    expect(Joosy.Resource).toBeDefined()

  it "should declare namespaces", ->
    Joosy.namespace 'Namespaces.Test1'
    Joosy.namespace 'Namespaces.Test2', ->
      @bingo = 'bongo'
    expect(window.Namespaces.Test1).toBeDefined()
    expect(window.Namespaces.Test2.bingo).toEqual('bongo')

  it "should imprint namespace paths in Joosy.Module descendants", ->
    Joosy.namespace 'Irish', ->
      class @Pub extends Joosy.Module

    Joosy.namespace 'British', ->
      class @Pub extends Joosy.Module

    Joosy.namespace 'Keltic', ->
      class @Pub extends Irish.Pub

    expect(Irish.Pub.__namespace__).toEqual ["Irish"]
    expect(British.Pub.__namespace__).toEqual ["British"]
    expect(Keltic.Pub.__namespace__).toEqual ["Keltic"]

    Joosy.namespace 'Deeply.Nested', ->
      class @Klass extends Joosy.Module

    expect(Deeply.Nested.Klass.__namespace__).toEqual ["Deeply", "Nested"]

    class @Flat extends Joosy.Module

    expect(@Flat.__namespace__).toEqual []

  it "should set up helpers", ->
    Joosy.helpers 'Hoge', ->
      @fuga = ->
        "piyo"

    expect(window.Joosy.Helpers).toBeDefined()
    expect(window.Joosy.Helpers.Hoge).toBeDefined()
    expect(window.Joosy.Helpers.Hoge.fuga()).toBe "piyo"

  it "should generate proper UUIDs", ->
    uuids = []
    2.times ->
      uuids.push Joosy.uuid()
    expect(uuids.unique().length).toEqual(2)
    expect(uuids[0]).toMatch /[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[0-9A-F]{4}-[0-9A-F]{12}/

  it "should build proper URLs", ->
    expect(Joosy.buildUrl 'http://www.org').toEqual('http://www.org')
    expect(Joosy.buildUrl 'http://www.org#hash').toEqual('http://www.org#hash')
    expect(Joosy.buildUrl 'http://www.org', {foo: 'bar'}).toEqual('http://www.org?foo=bar')
    expect(Joosy.buildUrl 'http://www.org?bar=baz', {foo: 'bar'}).toEqual('http://www.org?bar=baz&foo=bar')

  it "should preload images", ->
    path   = "/spec/javascripts/support/assets/"
    images = [path+"okay.jpg", path+"okay.jpg"]

    callback = sinon.spy()

    runs -> Joosy.preloadImages path+"coolface.jpg", callback
    waits(150)
    runs -> expect(callback.callCount).toEqual(1)

    runs -> Joosy.preloadImages images, callback
    waits(150)
    runs -> expect(callback.callCount).toEqual(2)

  it "should define resource", ->
    container = {}
    Joosy.defineResource 'foo', '', container
    expect(Object.isFunction container.Foo).toBeTruthy()
    expect(Object.isFunction container.FoosCollection).toBeTruthy()
    Joosy.defineResource 'boo'
    expect(Object.isFunction Boo).toBeTruthy()
    expect(Object.isFunction BoosCollection).toBeTruthy()

  it "should define resource", ->
    window.Defined = 'this'
    window.DefinedsCollection = 'that'
    Joosy.defineResources
      '':
        test: '/test'
        defined: 'no'
      'Scope.Test':
        another: ''
    expect(Object.isFunction Test).toBeTruthy()
    expect(Object.isFunction TestsCollection).toBeTruthy()
    expect(Object.isFunction Scope.Test.Another).toBeTruthy()
    expect(Object.isFunction Scope.Test.AnothersCollection).toBeTruthy()
    expect(Defined).toEqual 'this'
    expect(DefinedsCollection).toEqual 'that'
