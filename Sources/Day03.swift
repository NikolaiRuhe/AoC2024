import Algorithms

/// Mull It Over
/// https://adventofcode.com/2024/day/3
struct Day03: AdventDay {
  static let testData = """
    xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
    """

  static let testData2 = """
    xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
    """

  static var expectedTestResult1:   String { "161" }
  static var expectedProperResult1: String { "174103751" }
  static var expectedTestResult2:   String { "48" }
  static var expectedProperResult2: String { "100411201" }

  var data: String

  func part1() -> Any {
    data.sumOfProducts
  }

  func part2() -> Any {
    data
      .replacing(/don't\(\).*?(?:do\(\)|\Z)/.dotMatchesNewlines(), with: "<disabled>")
      .sumOfProducts
  }
}

extension String {
  var sumOfProducts: Int {
    matches(of: /mul\((?<lhs>\d{1,3}),(?<rhs>\d{1,3})\)/)
      .reduce(0) { $0 + Int($1.lhs)! * Int($1.rhs)! }
  }
}
