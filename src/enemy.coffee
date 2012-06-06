Enemy = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    enemy: true
    range: 50
    shoot: 0
    shootTimeout: 1
    damage: 3
    expValue: 5

  # Inherit from game object
  self = Creature(I).extend
    fire: (target) ->
      return if I.shoot

      I.shoot = I.shootTimeout

      engine.add "Bullet"
        target: target
        x: I.x
        y: I.y
        color: "red"
        damage: I.damage

  self.cooldown "shoot"

  self.on "destroy", ->
    wizards = engine.find("Wizard")

    (I.expValue / 5).ceil().times ->
      wizards.rand().expUp(5)

  self.on "hit", (damage) ->
    Sound.play "enemy_hit"

    engine.add "TextEffect.Floating",
      x: I.x
      y: I.y - 16
      velocity: Point(0, -30)
      text: damage
      color: "white"
      font: "bold #{16}px consolas, 'Courier New', 'andale mono', 'lucida console', monospace"
      duration: 0.75
      zIndex: 2 * App.height
      scale: 1.25

  # Add events and methods here
  self.on "update", ->
    I.target = null if I.target and I.target.I.active is false

    I.target = engine.find("Wizard").rand() unless I.target

    if I.target
      self.follow(I.target, 0.5)
      
      if Point.distance(self.position(), I.target.position()) < I.range
        self.fire(I.target)
        

  # We must always return self as the last line
  return self
