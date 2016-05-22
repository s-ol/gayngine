wrapping_ = (klass) ->
  getmetatable(klass).__call = (cls, self, ...) ->
    setmetatable self, cls.__base
    cls.__init self, ...

  klass


{
  :wrapping_,
}
