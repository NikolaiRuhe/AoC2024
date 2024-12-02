import Algorithms

/// Analyzing some unusual data from the Red-Nosed reactor.
struct Day02: AdventDay {
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
  var isSafe: Bool 	{
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
