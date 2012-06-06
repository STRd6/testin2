Target = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    color: "red"
    scale: 0.25
    rotationalVelocity: 0.25.turns
    sprite: "target"
    current: true
    
  self = GameObject(I).extend
    deactivate: ->
      I.current = false

      self.fadeOut 0.25, ->
        self.destroy()

  # We must always return self as the last line
  return self
