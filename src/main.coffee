# Create the engine
window.engine = Engine
  background: "cracked_dirt"
  canvas: $("canvas").pixieCanvas()
  FPS: 36

Sound.globalVolume 0.4
Music.play "fireblaster"
Music.volume 0.4

gameOver = false
victory = false
transitioning = false

# TODO: Extract this construct
currentWave = -1
waves = [
  ->
    5.times ->
      engine.add "Ant"
        x: App.width + rand()
        y: App.height
  ->
    10.times ->
      engine.add "Ant"
        x: App.width + rand()
        y: App.height/2 + rand()
  ->
    2.times ->
      engine.add "Newt"
        x: 0 + rand()
        y: App.height
  ->
    7.times ->
      engine.add "Ant"
        x: App.width + rand()
        y: App.height + rand()
    7.times ->
      engine.add "Ant"
        x: App.width + rand()
        y: 0 + rand()
  ->
    5.times ->
      engine.add "Crab"
      x: rand()
      y: rand()
  ->
    8.times ->
      engine.add "Ant"
        x: App.width + rand()
        y: App.height/2 + rand()
    8.times ->
      engine.add "Ant"
        x: 0 + rand()
        y: App.height/2 + rand()
  ->
    5.times ->
      engine.add "Crab"
      x: rand()
      y: rand()
    3.times ->
      engine.add "Newt"
      x: rand()
      y: rand()
  ->
    5.times ->
      engine.add "Ant"
        x: App.width + rand()
        y: App.height/2 + rand()
    7.times ->
      engine.add "Ant"
        x: 0 + rand()
        y: App.height/2 + rand()
    4.times ->
      engine.add "Crab"
      x: rand()
      y: rand()
    3.times ->
      engine.add "Newt"
      x: rand()
      y: rand()
  ->
    2.times ->
      engine.add "Newt"
      x: rand()
      y: rand()
    2.times ->
      engine.add "Newt"
      x: rand() + App.width
      y: rand()
    2.times ->
      engine.add "Newt"
      x: rand()
      y: rand() + App.height
    2.times ->
      engine.add "Newt"
      x: rand() + App.width
      y: rand() + App.height
  ->
    20.times ->
      engine.add "Ant"
        x: App.width + rand()
        y: App.height + rand()
  ->
    2.times ->
      engine.add "Newt"
      x: rand()
      y: rand()
    2.times ->
      engine.add "Newt"
      x: rand() + App.width
      y: rand()
    2.times ->
      engine.add "Newt"
      x: rand()
      y: rand() + App.height
    2.times ->
      engine.add "Newt"
      x: rand() + App.width
      y: rand() + App.height
    10.times ->
      engine.add "Ant"
        x: App.width + rand()
        y: App.height / 2 + rand()
    10.times ->
      engine.add "Ant"
        x: 0 + rand()
        y: App.height / 2 + rand()
    3.times ->
      engine.add "Crab"
      x: rand() + App.width/2
      y: rand()
    3.times ->
      engine.add "Crab"
      x: rand() + App.width/2
      y: rand() + App.height
]

nextWave = ->
  return if transitioning
  transitioning = true

  currentWave += 1

  if wave = waves[currentWave]
    engine.add "Wizard"
    engine.delay 3, ->
      transitioning = false
      wave()
  else
    gameOver = true

2.times (i) ->
  engine.add "Wizard"
    id: i

engine.bind 'update', ->
  nextWave() unless engine.first(".enemy")

  if mousePressed.left
    engine.find("Target").invoke "deactivate"
    
    engine.add "Target",
      x: mousePosition.x
      y: mousePosition.y

# Start the engine
engine.start()
