Flock = (I={}, self) ->
  Object.reverseMerge I,
    localityDistanceSquared: 256*256

  nearby = (entity) ->
    Point.distanceSquared(self.position(), entity.position()) <= I.localityDistanceSquared

  cohere: (selector, weight=0.1) ->
    entities = engine.find(selector).select(nearby)

    if n = entities.length
      # TODO: Array average that works with points
      averagePosition = entities.inject Point(0, 0), (p, e) ->
        p.add(e.position())
      .scale(1 / n)

      cohereVelocity = averagePosition.subtract(self.position()).norm(I.speed)

      I.velocity = Point.interpolate(I.velocity, cohereVelocity, weight)

  align: (selector, weight=0.5) ->
    entities = engine.find(selector).select(nearby)

    if n = entities.length
      # TODO: Array average that works with points
      averageVelocity = entities.inject Point(0, 0), (p, e) ->
        p.add(e.I.velocity)
      .scale(1 / n)

      I.velocity = Point.interpolate(I.velocity, averageVelocity, weight)

  separate: (selector, weight=200) ->
    entities = engine.find(selector)

    f = Point(0, 0)
    p1 = self.position()

    entities.each (entity) ->
      if entity != self
        p2 = entity.position()
        if (distanceSquared = Point.distanceSquared(p2, p1)) < 10000 and distanceSquared > 0
          f = f.add(p1.subtract(p2).scale(weight / distanceSquared))

    I.velocity = I.velocity.add(f)

  # This overrides the default follow behavior
  follow: (selector, weight=0.1) ->
    if selector.isString?()
      currentTarget = engine.first(selector)
      if currentTarget
        p = currentTarget.position()
    else if p = selector.position?()
    else
      p = selector

    if p
      targetVelocity = p.subtract(self.position()).norm(I.speed)
  
      I.velocity = Point.interpolate(I.velocity, targetVelocity, weight)
