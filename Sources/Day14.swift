import Algorithms

// https://adventofcode.com/2024/day/14
struct Day14: AdventDay {
  static let testData = """
    p=0,4 v=3,-3
    p=6,3 v=-1,-3
    p=10,3 v=-1,2
    p=2,0 v=2,-1
    p=0,0 v=1,3
    p=3,0 v=-2,-2
    p=7,6 v=-1,-3
    p=3,0 v=-1,-2
    p=9,3 v=2,3
    p=7,3 v=-1,2
    p=2,4 v=2,-3
    p=9,5 v=-3,-3
    """

  static var expectedTestResult1:   String { "12" }
  static var expectedProperResult1: String { "225810288" }
  static var expectedTestResult2:   String { "unknown" }
  static var expectedProperResult2: String { "6752" }

  var bots: [Bot]
  var size: (x: Int, y: Int) = (x: 101, y: 103)

  init(data: String) {
    if data == Self.testData {
      size = (x: 11, y: 7)
    }
    self.bots = data.split(separator: "\n")
      .map { Bot($0) }
  }

  func part1() -> Any {
    bots
      .map { $0.quadrantAfterMoving(seconds: 100, width: size.x, height: size.y) }
      .filter { $0 != 0 }
      .grouped(by: \.self)
      .values
      .map { $0.count }
      .reduce(1, *)
  }

  func part2() -> Any {
    var bots = self.bots
    let bitmap = Array<UInt128>(repeating: 0 as UInt128, count: size.y)
    for seconds in 1... {

      for i in bots.indices {
        bots[i].move(seconds: 1, width: size.x, height: size.y)
      }

      let botmap = bots.reduce(into: bitmap) {
        $0[$1.position.y] |= 1 << UInt128($1.position.x)
      }

      let hasLongSpan = botmap.contains {
        var bits = $0
        bits = (bits << 1) & bits
        bits = (bits << 2) & bits
        bits = (bits << 4) & bits
        bits = (bits << 8) & bits
        return bits != 0
      }

      if hasLongSpan {
        var grid = Array(repeating: Array(repeating: false, count: size.x + 1), count: size.y + 1)
        bots
          .forEach { bot in grid[bot.position.y][bot.position.x] = true }

        print(grid.map { String($0.map { $0 ? "#" : "." }) }.joined(separator: "\n"))
        return seconds
      }
    }
    fatalError()
  }

  struct Bot {
    var position: (x: Int, y: Int)
    var speed: (x: Int, y: Int)

    init(_ data: Substring) {
      let m = data.firstMatch(of: /p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)/)!
      self.position = (Int(m.1)!, Int(m.2)!)
      self.speed = (Int(m.3)!, Int(m.4)!)
    }

    mutating func move(seconds: Int, width: Int, height: Int) {
      position.x = (position.x + speed.x * seconds) % width
      position.y = (position.y + speed.y * seconds) % height
      if position.x < 0 { position.x += width }
      if position.y < 0 { position.y += height }
    }

    func quadrantAfterMoving(seconds: Int, width: Int, height: Int) -> Int {
      var x = (position.x + speed.x * seconds) % width
      var y = (position.y + speed.y * seconds) % height
      if x < 0 { x += width }
      if y < 0 { y += height }

      if x == width / 2 || y == height / 2 { return 0 }
      if x < width / 2 {
        return y < height / 2 ? 2 : 1
      } else {
        return y < height / 2 ? 3 : 4
      }
    }
  }
}
