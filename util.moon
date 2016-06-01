wrapping_ = (klass) ->
  getmetatable(klass).__call = (cls, self, ...) ->
    setmetatable self, cls.__base
    cls.__init self, ...

  klass

class Reloadable
  new: =>
    info = debug.getinfo 2
    file = string.match info.source, "@%.?[/\\]?(.*)"

    @module = info.source\match "@%.?[/\\]?(.*)%.%a+"
    @module = @module\gsub "/", "."

    if WATCHER
      WATCHER\register file, @

  reload: (filename) =>
    print "reloading #{@module}..."

    package.loaded[@module] = nil
    require @module

class Mixin extends Reloadable
  find_tag: =>
    layer = @
    while not layer.tag
      layer = layer.parent

      if not layer
        return nil

    layer.tag

  reload: (...) =>
    new = super ...

    setmetatable @, new.__base

{
  :wrapping_,
  :Reloadable,
  :Mixin,
}
