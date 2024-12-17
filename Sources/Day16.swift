import Algorithms

// Reindeer Maze
// https://adventofcode.com/2024/day/16
struct Day16: AdventDay {
  static let testData = """
    #################
    #...#...#...#..E#
    #.#.#.#.#.#.#.#^#
    #.#.#.#...#...#^#
    #.#.#.#.###.#.#^#
    #>>v#.#.#.....#^#
    #^#v#.#.#.#####^#
    #^#v..#.#.#>>>>^#
    #^#v#####.#^###.#
    #^#v#..>>>>^#...#
    #^#v###^#####.###
    #^#v#>>^#.....#.#
    #^#v#^#####.###.#
    #^#v#^........#.#
    #^#v#^#########.#
    #S#>>^..........#
    #################
    """

  static var expectedTestResult1:   String { "11048" }
  static var expectedProperResult1: String { "75416" }
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

      var pathsToFollow: [(pos: Coord, dir: Direction)] = []
      pathsToFollow.append((startPos, .e))
      pathsToFollow.append((startPos, .n))
      pathsToFollow.append((startPos, .s))
      pathsToFollow.append((startPos, .w))

      while pathsToFollow.isEmpty == false {
        let path = pathsToFollow.removeLast()
        let dir = path.dir
        let pos = path.pos + dir
        guard walls[pos] == false else { continue }
        let score = scores[path.pos][dir] + 1

        func go(_ dir: Direction, score: Int) {
          guard score < scores[pos][dir] else { return }
          scores[pos][dir] = score
          pathsToFollow.append((pos, dir))
        }

        go(dir.opposite, score: score + 2000)
        go(dir.cw,       score: score + 1000)
        go(dir.ccw,      score: score + 1000)
        go(dir,          score: score)
      }

      return min(scores[endPos].n, scores[endPos].s, scores[endPos].e, scores[endPos].w)
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
