import Algorithms

/// Red-Nosed Reports.
/// https://adventofcode.com/2024/day/2
struct Day02: AdventDay {
  static let testData = """
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9
    """

  static var expectedTestResult1:   String { "2" }
  static var expectedProperResult1: String { "269" }
  static var expectedTestResult2:   String { "4" }
  static var expectedProperResult2: String { "337" }

  var data: String

  var reports: [Report] {
    data.split(separator: "\n").map { line in
      line
        .split(separator: /\s+/)
        .map { Int($0)! }
    }
  }

  func part1() -> Any {
    reports.count { $0.isSafe }
  }

  func part2() -> Any {
    reports.count { $0.isModeratelySafe }
  }

  typealias Report = [Int]
}

extension Day02.Report {
  var isSafe: Bool   {
    let diffs = adjacentPairs().map { $1 - $0 }
    return diffs.allSatisfy { (1...3).contains($0) }
    || diffs.allSatisfy { (1...3).contains(-$0) }
  }

  var isModeratelySafe: Bool {
    for i in indices {
      var copy = self
      copy.remove(at: i)
      if copy.isSafe { return true }
    }
    return isSafe
  }
}
