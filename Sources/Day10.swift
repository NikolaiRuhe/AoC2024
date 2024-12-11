import Algorithms

/// Hoof It
/// https://adventofcode.com/2024/day/10
struct Day10: AdventDay {
  static let testData = """
    89010123
    78121874
    87430965
    96549874
    45678903
    32019012
    01329801
    10456732
    """

  static var expectedTestResult1:   String { "36" }
  static var expectedProperResult1: String { "472" }
  static var expectedTestResult2:   String { "81" }
  static var expectedProperResult2: String { "969" }

  var map: Map
  init(data: String) { self.map = Map(data) }

  func part1() -> Any { map.score1 }
  func part2() -> Any { map.score2 }

  struct Map {
    var map: [[UInt8]]
    var dim: (rows: Int, cols: Int)

    init(_ data: String) {
      let lines = data.split(separator: "\n")
      self.dim = (rows: lines.count, cols: lines[0].count)
      self.map = lines.map { $0.map { $0.asciiValue! - 48 } }
    }

    var score1: Int {
      return startPositions.map {
        pathScore(row: $0.0, col: $0.1).0
      }.reduce(0, +)
    }

    var score2: Int {
      return startPositions.map {
        pathScore(row: $0.0, col: $0.1).1
      }.reduce(0, +)
    }

    var startPositions: [(row: Int, col: Int)] { map
      .enumerated()
      .flatMap { row, cells in
        cells
          .enumerated()
          .filter { _, height in height == 0 }
          .map { col, _ in (row, col) }
      }
    }

    func pathScore(row: Int, col: Int) -> (Int, Int) {
      var destinations: Set<Int> = []
      var pathCount = 0

      func traversePath(height: Int, row: Int, col: Int) {
        guard map[row][col] == height else { return }
        guard height != 9 else {
          destinations.insert(row << 16 | col)
          pathCount += 1
          return
        }
        if (row > 0            ) { traversePath(height: height + 1, row: row - 1, col: col) }
        if (row + 1 != dim.rows) { traversePath(height: height + 1, row: row + 1, col: col) }
        if (col > 0            ) { traversePath(height: height + 1, row: row, col: col - 1) }
        if (col + 1 != dim.cols) { traversePath(height: height + 1, row: row, col: col + 1) }
      }

      traversePath(height: 0, row: row, col: col)
      return (destinations.count, pathCount)
    }
  }
}
