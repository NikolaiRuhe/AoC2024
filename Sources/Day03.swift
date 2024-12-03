import Algorithms

struct Day03: AdventDay {
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
