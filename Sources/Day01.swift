import Algorithms

/// Historian Hysteria
/// https://adventofcode.com/2024/day/1
struct Day01: AdventDay {
  static let testData = """
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
    """

  static var expectedTestResult1:   String { "11" }
  static var expectedProperResult1: String { "1151792" }
  static var expectedTestResult2:   String { "31" }
  static var expectedProperResult2: String { "21790168" }

  var data: String

  var entities: [(Int, Int)] {
    data.split(separator: "\n").map {
      let pair = $0.split(separator: /\s+/).map { Int($0)! }
      return (pair[0], pair[1])
    }
  }

  var left:  [Int] { entities.map { $0.0 } }
  var right: [Int] { entities.map { $0.1 } }

  var rightOccurrences: [Int: Int] {
    .init(
      uniqueKeysWithValues: right
        .sorted()
        .chunked(by: ==)
        .map { ($0.first!, $0.count) }
    )
  }

  func part1() -> Any {
    zip(left.sorted(), right.sorted())
      .map { abs($0 - $1) }
      .reduce(0, +)
  }

  func part2() -> Any {
    let occurrences = rightOccurrences

    return left
      .map { $0 * (occurrences[$0] ?? 0) }
      .reduce(0, +)
  }
}
