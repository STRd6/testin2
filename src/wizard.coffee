# Player class constructor
Wizard = (I={}) ->
  # Default values that can be overriden when creating a new player.
  Object.reverseMerge I,
    speed: 100
    sprite: "wizard"
    radius: 16
    x: App.width/2 + rand()
    y: App.height/2 + rand()
    shoot: 0
    exp: 0
    expAccum: 0
    level: 1
    
  gainExp = ->
    if I.expAccum
      engine.add "TextEffect.Floating",
        x: I.x
        y: I.y
        text: "+#{I.expAccum}"
        color: "yellow"
        font: "bold #{16}px consolas, 'Courier New', 'andale mono', 'lucida console', monospace"
        duration: 1
        zIndex: 2 * App.height

      I.exp += I.expAccum
      I.expAccum = 0

      if I.level < 2 and I.exp > 10
        levelUp()

      if I.level < 3 and I.exp > 25
        levelUp()
        
      if I.level < 4 and I.exp > 50
        levelUp()
        
      if I.level < 5 and I.exp > 100
        levelUp()

  levelUp = ->
    I.level += 1
    
    I.healthMax += 25
    I.health = I.healthMax
    
    engine.add "TextEffect.Floating",
      x: I.x
      y: I.y - 16
      text: "Level Up!"
      color: "gold"
      font: "bold #{16}px consolas, 'Courier New', 'andale mono', 'lucida console', monospace"
      duration: 2
      zIndex: 2 * App.height
      velocity: Point(0, -15)

  # The player is a GameObject
  self = Creature(I).extend
    expUp: (exp) ->
      I.expAccum += exp

    fire: (target) ->
      return if I.shoot

      if enemy = engine.closest(".enemy", target)
        I.shoot = 0.25

        Sound.play "shoot"

        engine.add "Bullet"
          target: enemy
          x: I.x
          y: I.y
          sprite: if I.level >= 3 then "flame" else "spark"
          damage: (2 + I.level) * ((I.level / 3).floor() + 1)

  if I.id is 0
    self.include "Debuggable"
    # self.debug filter: 'changed'

  self.cooldown "shoot"

  self.on "create", ->
    Sound.play "powerup"

  self.on "hit", (damage) ->
    Sound.play "hit"
    
    engine.add "TextEffect.Floating",
      x: I.x
      y: I.y
      text: damage
      color: "red"
      font: "bold #{16}px consolas, 'Courier New', 'andale mono', 'lucida console', monospace"
      duration: 1
      zIndex: 2 * App.height

  self.on "destroy", ->
    Sound.play "wizard_die"

  self.on "update", (elapsedTime) ->
    self.follow("Target.current")
    self.separate(".enemy")
    
    gainExp()

    if I.level >= 3
      I.sprite = Wizard.redSprite

    self.fire(mousePosition) if mouseDown.right

  # We must return a reference to self from the constructor
  return self

Wizard.redSprite = Sprite.loadByName("red_wizard")
