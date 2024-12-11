import Algorithms

/// Print Queue
/// https://adventofcode.com/2024/day/5
struct Day05: AdventDay {
  static let testData = """
    47|53
    97|13
    97|61
    97|47
    75|29
    61|13
    75|53
    29|13
    97|29
    53|29
    61|53
    97|53
    61|29
    47|13
    75|47
    97|75
    47|61
    75|61
    47|29
    75|13
    53|13

    75,47,61,53,29
    97,61,53,29,13
    75,29,13
    75,97,47,61,53
    61,13,29
    97,13,75,29,47
    """

  static var expectedTestResult1:   String { "143" }
  static var expectedProperResult1: String { "5275" }
  static var expectedTestResult2:   String { "123" }
  static var expectedProperResult2: String { "6191" }

  var order: [String: Bool]
  var updates: [[Int]]

  init(data: String) {
    let parts = data.split(separator: "\n\n").map { $0.split(separator: "\n") }

    self.order = Dictionary(uniqueKeysWithValues: parts[0].map {
      $0.split(separator: "|").map { Int($0)! }
    }.flatMap { e in
      [("\(e[0])_\(e[1])", true), ("\(e[1])_\(e[0])", false)]
    })

    self.updates = parts[1].map { $0.split(separator: ",").map { Int($0)! } }
  }

  func sortOrder(a: Int, b: Int) -> Bool { order["\(a)_\(b)"] ?? false }

  func part1() -> Any {
    updates
      .filter { $0.sorted(by: sortOrder) == $0 }
      .map { $0[$0.count / 2] }
      .reduce(0, +)
  }

  func part2() -> Any {
    updates
      .filter { $0.sorted(by: sortOrder) != $0 }
      .map { $0.sorted(by: sortOrder)[$0.count / 2] }
      .reduce(0, +)
  }
}
