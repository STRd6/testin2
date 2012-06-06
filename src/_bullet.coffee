# HEY LISTEN!
# This file is auto-generated, so editing it directly is a bad idea.
# Modify the entity that generated it instead!
Bullet = (I={}) ->
  Object.reverseMerge I, {
    "class": "Bullet",
    "parentClass": "GameObject",
    "color": "blue",
    "radius": 3,
    "__CODE": "targetPosition = I.target.position()\n\nI.rotation = Point.direction(self.position(), targetPosition)\n\nself.tween 0.25,\n  x: targetPosition.x\n  y: targetPosition.y\n  complete: ->\n    self.destroy()\n    I.target.hit(I.damage)\n",
    "uuid": "bullet",
    "damage": 10
  }

  self = GameObject(I)

  targetPosition = I.target.position()
  
  I.rotation = Point.direction(self.position(), targetPosition)
  
  self.tween 0.25,
    x: targetPosition.x
    y: targetPosition.y
    complete: ->
      self.destroy()
      I.target.hit(I.damage)
  

  return self