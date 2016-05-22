class Pool
  add: (drawable, x, y, ox, oy, shader, color) =>
    table.insert @pool, {:shader, :color, :drawable, :x, :y, :ox, :oy}

  draw: =>
    table.sort @pool, (a, b) -> a.y < b.y
    
