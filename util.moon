wrapping_ = (klass) ->
  getmetatable(klass).__call = (cls, self, ...) ->
    setmetatable self, cls.__base
    cls.__init self, ...

  klass

class Mixin
  new: =>
    info = debug.getinfo 2
    file = info.source\match "@%./(.*)"

    @module = info.source\match "@%./(.*)%.moon"
    @module = @module\gsub "/", "."

    WATCHER\register file, @

  reload: (filename) =>
    print "reloading #{@module}..."

    package.loaded[@module] = nil
    new = require @module

    setmetatable @, new.__base

  find_tag: =>
    layer = @
    while not layer.tag
      layer = layer.parent

      if not layer
        return nil

    layer.tag

{
  :wrapping_,
  :Mixin
}
