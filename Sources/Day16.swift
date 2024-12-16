import Algorithms

// Reindeer Maze
// https://adventofcode.com/2024/day/16
struct Day16: AdventDay {
  static let testData = """
    ###############
    #.......#....E#
    #.#.###.#.###.#
    #.....#.#...#.#
    #.###.#####.#.#
    #.#.#.......#.#
    #.#.#####.###.#
    #...........#.#
    ###.#.#####.#.#
    #...#.....#.#.#
    #.#.#.###.#.#.#
    #.....#...#.#.#
    #.###.#.#.#.#.#
    #S..#.....#...#
    ###############
    """

  static var expectedTestResult1:   String { "7036" }
  static var expectedProperResult1: String { "unknown" }
  static var expectedTestResult2:   String { "unknown" }
  static var expectedProperResult2: String { "unknown" }

  var map: Map
  init(data: String) { self.map = Map(data.split(separator: "\n")) }

  func part1() -> Any { map.calculateScores() }
  func part2() -> Any { "not implemented" }

  struct Map {
    var walls: [[Bool]]
    var startPos: Coord
    var endPos: Coord

    init(_ lines: [Substring]) {
      self.walls = lines.map { $0.map { $0 == "#" } }
      self.startPos = lines.coordinates.first(where: { lines[$0] == "S" })!
      self.endPos   = lines.coordinates.first(where: { lines[$0] == "E" })!
    }

    func calculateScores() -> Int {
      var scores = Array(
        repeating: Array(
          repeating: Scores(n: .max, s: .max, e: .max, w: .max),
          count: walls[0].count
        ),
        count: walls.count
      )

      scores[startPos].e = 0
      scores[startPos].n = 1000
      scores[startPos].s = 1000
      scores[startPos].w = 2000

      go(.e, from: startPos)
      go(.n, from: startPos)
      go(.s, from: startPos)
      go(.w, from: startPos)

      return min(scores[endPos].n, scores[endPos].s, scores[endPos].e, scores[endPos].w)

      func go(_ dir: Direction, from oldPos: Coord) {
        let pos = oldPos + dir
        guard walls[pos] == false else { return }
        let score = scores[oldPos][dir] + 1
//        print("\(oldPos) -> \(dir) -> \(pos), score \(score)")
//        printMap(robotAt: pos)
        let d1 = score +    0 < scores[pos][dir]
        let d2 = score + 1000 < scores[pos][dir.cw]
        let d3 = score + 1000 < scores[pos][dir.ccw]
        let d4 = score + 2000 < scores[pos][dir.cw.cw]
        if d1 { scores[pos][dir]       = score +    0 }
        if d2 { scores[pos][dir.cw]    = score + 1000 }
        if d3 { scores[pos][dir.ccw]   = score + 1000 }
        if d4 { scores[pos][dir.cw.cw] = score + 2000 }
        if d1 { go(dir,       from: pos) }
        if d2 { go(dir.cw,    from: pos) }
        if d3 { go(dir.ccw,   from: pos) }
        if d4 { go(dir.cw.cw, from: pos) }
      }
    }

    func printMap(robotAt pos: Coord) {
      let map = walls.map {
        String($0.map { $0 ? "#" : "." })
      }.joined(separator: "\n")

      let o = pos.row * (1 + walls[0].count) + pos.col
      print(map.prefix(o), "@", map.dropFirst(o + 1), separator: "")
    }
  }

  struct Scores {
    var n: Int
    var s: Int
    var e: Int
    var w: Int
    subscript(_ direction: Direction) -> Int {
      get {
        switch direction {
        case .n: n
        case .s: s
        case .e: e
        case .w: w
        }
      }
      set {
        switch direction {
        case .n: n = newValue
        case .s: s = newValue
        case .e: e = newValue
        case .w: w = newValue
        }
      }
    }
  }
}
