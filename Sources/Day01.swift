import Algorithms

/// Missing Chief Historian
struct Day01: AdventDay {
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
