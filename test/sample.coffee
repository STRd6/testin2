test "This is a sample test", ->
  ok(true, "Just testing an assertion.")

  actual = 2
  expected = 2
  equal(actual, expected, "Testing an equality assertion")

