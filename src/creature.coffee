Creature = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    color: "blue"
    radius: 16
    speed: 90
    armor: 1
    health: 100
    damageAccum: 0
    
  realizeDamage = ->
    if I.damageAccum
      damage = I.damageAccum
      I.health -= damage
      I.damageAccum = 0

      self.trigger "hit", damage

  self = GameObject(I).extend
    hit: (damage) ->
      damage = (damage - I.armor).clamp(0, Infinity)
      I.damageAccum += damage

  self.on "create", ->
    I.healthMax ||= I.health

  self.include "Flock"

  # Add events and methods here
  self.on "update", ->
    if I.health <= 0
      self.destroy()
      
    self.meter "health"
      x: I.x - 10
      y: I.y + 20
      width: (I.healthMax / 5).clamp(20, 250)

  self.on "afterUpdate", ->
    realizeDamage()
    
    self.separate(I.class)
    self.align(I.class)
    self.cohere(I.class)

    I.velocity = I.velocity.norm(I.speed)

    if I.x < 0 and I.velocity.x < 0
      I.velocity.x = -I.velocity.x
    if I.y < 0 and I.velocity.y < 0
      I.velocity.y = -I.velocity.y
    if I.x > App.width and I.velocity.x > 0
      I.velocity.x = -I.velocity.x
    if I.y > App.height and I.velocity.y > 0
      I.velocity.y = -I.velocity.y
      
    I.zIndex = I.y

  # We must always return self as the last line
  return self
