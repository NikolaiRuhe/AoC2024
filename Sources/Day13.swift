import Algorithms

// https://adventofcode.com/2024/day/13
struct Day13: AdventDay {
  static let testData = """
    Button A: X+94, Y+34
    Button B: X+22, Y+67
    Prize: X=8400, Y=5400

    Button A: X+26, Y+66
    Button B: X+67, Y+21
    Prize: X=12748, Y=12176

    Button A: X+17, Y+86
    Button B: X+84, Y+37
    Prize: X=7870, Y=6450

    Button A: X+69, Y+23
    Button B: X+27, Y+71
    Prize: X=18641, Y=10279
    """

  static var expectedTestResult1:   String { "480" }
  static var expectedProperResult1: String { "36758" }
  static var expectedTestResult2:   String { "875318608908" }
  static var expectedProperResult2: String { "76358113886726" }

  var machines: [Machine]

  init(data: String) {
    self.machines = data
      .split(separator: "\n\n")
      .map { Machine(input: $0) }
  }

  func part1() -> Any {
    return machines
      .compactMap(\.minimalTokens)
      .reduce(0, +)
  }

  func part2() -> Any {
    return machines
      .map {
        var new = $0;
        new.prize.x = new.prize.x + 10000000000000
        new.prize.y = new.prize.y + 10000000000000
        return new
      }
      .compactMap(\.nicosSolution)
      .reduce(0, +)
  }

  struct Machine {
    var buttonA: (x: Int, y: Int)
    var buttonB: (x: Int, y: Int)
    var prize: (x: Int, y: Int)

    init(input: Substring) {
      var m = input.firstMatch(of: /Button A: X\+(?<x>\d+), Y\+(?<y>\d+)/)!
      self.buttonA = (x: Int(m.x)!, y: Int(m.y)!)
      m = input.firstMatch(of: /Button B: X\+(?<x>\d+), Y\+(?<y>\d+)/)!
      self.buttonB = (x: Int(m.x)!, y: Int(m.y)!)
      m = input.firstMatch(of: /Prize: X=(?<x>\d+), Y=(?<y>\d+)/)!
      self.prize = (x: Int(m.x)!, y: Int(m.y)!)
    }

    var minimalTokens: Int? {
      let maxA = min(prize.x / buttonA.x + 1, prize.y / buttonA.y + 1)
      let maxB = min(prize.x / buttonB.x + 1, prize.y / buttonB.y + 1)

      return (0...maxA)
        .flatMap { na in (0...maxB).map { nb in (na, nb) } }
        .filter { (na, nb) in
          let x = na * buttonA.x + nb * buttonB.x
          let y = na * buttonA.y + nb * buttonB.y
          return x == prize.x && y == prize.y
        }
        .map { (na, nb) in return na * 3 + nb }
        .min()
    }

    var nicosSolution: Int? {
      let det = buttonA.x * buttonB.y - buttonA.y * buttonB.x
      guard det != 0 else { return nil }
      let na = (prize.x * buttonB.y - prize.y * buttonB.x)
      let nb = (prize.y * buttonA.x - prize.x * buttonA.y)
      guard na.isMultiple(of: det) && nb.isMultiple(of: det) else { return nil }
      return na / det * 3 + nb / det
    }
  }
}
