import Algorithms

/// Ceres Search
/// https://adventofcode.com/2024/day/4
struct Day04: AdventDay {
  static let testData = """
    MMMSXXMASM
    MSAMXMSMSA
    AMXSXMAAMM
    MSAMASMSMX
    XMASAMXAMM
    XXAMMXXAMA
    SMSMSASXSS
    SAXAMASAAA
    MAMMMXMMMM
    MXMXAXMASX
    """

  static var expectedTestResult1:   String { "18" }
  static var expectedProperResult1: String { "2547" }
  static var expectedTestResult2:   String { "9" }
  static var expectedProperResult2: String { "1939" }

  var data: String
  var grid: Grid

  init(data: String) {
    self.data = data
    self.grid = Grid(data)
  }

  func part1() -> Any { grid.wordCount }

  func part2_alt() -> Any {
    var xCount = 0
    let rows = grid.rows.map { Array($0) }
    for r in rows.indices.dropFirst().dropLast() {
      let row = rows[r]
      for c in row.indices.dropFirst().dropLast() where row[c] == "A" {
        if String([rows[r-1][c-1], rows[r+1][c+1]].sorted()) != "MS" { continue }
        if String([rows[r+1][c-1], rows[r-1][c+1]].sorted()) != "MS" { continue }
        xCount += 1
      }
    }
    return xCount
  }

  func part2() -> Any {
    let width = data.split(separator: "\n", maxSplits: 1)[0].count
    let gap = ".{\(width - 1)}"

    return [
      "M.M\(gap)A\(gap)S.S",
      "M.S\(gap)A\(gap)M.S",
      "S.S\(gap)A\(gap)M.M",
      "S.M\(gap)A\(gap)S.M",
    ]
      .map { try! Regex($0).dotMatchesNewlines() }
      .map { regex in
        var count = 0
        var pos = data.startIndex
        while let match = data[pos...].firstMatch(of: regex) {
          count += 1
          pos = match.0.dropFirst().startIndex
        }
        return count
      }
      .reduce(0, +)
  }

  struct Grid {
    var rows: [Substring]
    init(rows: [Substring]) { self.rows = rows }
    init(_ data: String) { self.rows = data.split(separator: "\n") }

    var wordCount: Int {
      let rot45 = rotated(diagonally: true)
      let rot90 = rotated()
      let rot135 = rot90.rotated(diagonally: true)

      return [self, rot45, rot90, rot135]
        .flatMap { $0.rows }
        .reduce(0) {
          $0 + $1.matches(of: /XMAS/).count + $1.matches(of: /SAMX/).count
        }
    }

    func rotated(diagonally: Bool = false) -> Grid {
      let cursors = rows.reversed()
        .map { var i = $0.makeIterator(); return { i.next() } }

      let rows = sequence<String>(state: 0) { rowCount in
        rowCount += 1
        let line = cursors
          .prefix(diagonally ? rowCount : .max)
          .compactMap { $0() }
        return line.isEmpty ? nil : Substring(line)
      }

      return Grid(rows: Array(rows))
    }
  }
}
