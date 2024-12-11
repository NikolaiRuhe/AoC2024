import Algorithms
import Darwin

/// Bridge Repair
/// https://adventofcode.com/2024/day/7
struct Day07: AdventDay {
  static let testData = """
    190: 10 19
    3267: 81 40 27
    83: 17 5
    156: 15 6
    7290: 6 8 6 15
    161011: 16 10 13
    192: 17 8 14
    21037: 9 7 18 13
    292: 11 6 16 20
    """

  static var expectedTestResult1:   String { "3749" }
  static var expectedProperResult1: String { "12553187650171" }
  static var expectedTestResult2:   String { "11387" }
  static var expectedProperResult2: String { "96779702119491" }

  var equations: [Equation]

  init(data: String) {
    self.equations = data.split(separator: "\n")
      .map { $0.split(separator: ":") }
      .map { Equation.init(result: Int($0[0])!, operands: $0[1].split(separator: /\s+/).map { Int($0)! })}
  }

  func part1() -> Any {
    return equations
      .filter { $0.isSolvable(isCatAllowed: false) }
      .map { $0.result }
      .reduce(0, +)
  }

  func part2() -> Any {
    return equations
      .filter { $0.isSolvable(isCatAllowed: true) }
      .map { $0.result }
      .reduce(0, +)
  }

  struct Equation {
    var result: Int
    var operands: [Int]

    init(result: Int, operands: [Int]) {
      self.result = result
      self.operands = operands
      assert(operands.allSatisfy { $0 >= 1 })
    }

    func isSolvable(from index: Int = 0, partialResult: Int = 0, isCatAllowed: Bool = false) -> Bool {
      guard index != operands.count else { return partialResult == result }

      let operand = operands[index]

      let add = partialResult + operand
      let mul = partialResult * operand
      let cat = isCatAllowed ? partialResult || operand : .max

      func traverse(with partialResult: Int) -> Bool {
        isSolvable(from: index + 1, partialResult: partialResult, isCatAllowed: isCatAllowed)
      }

      if add <= result && traverse(with: add) { return true }
      if mul <= result && traverse(with: mul) { return true }
      if cat <= result && traverse(with: cat) { return true }

      return false
    }
  }
}

fileprivate func || (lhs: Int, rhs: Int) -> Int {
  var shift = rhs
  var result = lhs
  repeat {
    result *= 10
    shift /= 10
  } while shift > 0
  return result + rhs
}
