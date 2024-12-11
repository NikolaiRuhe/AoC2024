import Algorithms

/// Resonant Collinearity
/// https://adventofcode.com/2024/day/8
struct Day08: AdventDay {
  static let testData = """
    ............
    ........0...
    .....0......
    .......0....
    ....0.......
    ......A.....
    ............
    ............
    ........A...
    .........A..
    ............
    ............
    """

  static var expectedTestResult1:   String { "14" }
  static var expectedProperResult1: String { "249" }
  static var expectedTestResult2:   String { "34" }
  static var expectedProperResult2: String { "905" }

  var antennas: [Character: [Coord]] = [:]
  var width: Int
  var height: Int

  init(data: String) {
    let lines = data.split(separator: "\n")
    self.width = lines[0].count
    self.height = lines.count

    for (row, line) in lines.enumerated() {
      for (col, char) in line.enumerated() where char != "." {
        antennas[char, default: []].append(Coord(row: row, col: col))
      }
    }
  }

  var coordinatePairs: some Sequence<(Coord, Coord)> {
    antennas
      .values
      .flatMap {
        $0.combinations(ofCount: 2).map { ($0[0], $0[1]) }
      }
  }

  func isInRange(_ coord: Coord) -> Bool {
    return coord.row >= 0 && coord.row < height && coord.col >= 0 && coord.col < width
  }

  func part1() -> Any {
    var result: Set<Coord> = []
    func insert(_ coord: Coord) { if isInRange(coord) { result.insert(coord) } }

    for (lhs, rhs) in coordinatePairs {
      let distance = lhs - rhs
      insert(lhs + distance)
      insert(rhs - distance)
    }

    return result.count
  }

  func part2() -> Any {
    var result: Set<Coord> = []

    for (lhs, rhs) in coordinatePairs {
      let distance = lhs - rhs
      var pos = lhs
      while isInRange(pos) { result.insert(pos); pos = pos + distance }
      pos = lhs - distance
      while isInRange(pos) { result.insert(pos); pos = pos - distance }
    }

    return result.count
  }

  struct Coord: Hashable {
    var row: Int
    var col: Int
  }
}

func + (lhs: Day08.Coord, rhs: Day08.Coord) -> Day08.Coord {
  .init(row: lhs.row + rhs.row, col: lhs.col + rhs.col)
}

func - (lhs: Day08.Coord, rhs: Day08.Coord) -> Day08.Coord {
  .init(row: lhs.row - rhs.row, col: lhs.col - rhs.col)
}
