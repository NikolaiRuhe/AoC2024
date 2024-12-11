import Algorithms

// Plutonian Pebbles
// https://adventofcode.com/2024/day/11
struct Day11: AdventDay {
  static let testData = """
    125 17
    """

  static var expectedTestResult1:   String { "55312" }
  static var expectedProperResult1: String { "229043" }
  static var expectedTestResult2:   String { "65601038650482" }
  static var expectedProperResult2: String { "272673043446478" }

  var numbers: [Int]

  init(data: String) {
    self.numbers = data
      .split(separator: /\s+/)
      .map { Int($0)! }
  }

  func part1() -> Any {
    let pebbles = Pebbles(numbers: numbers)
    return pebbles.pebbleCount(after: 25)
  }

  func part2() -> Any {
    let pebbles = Pebbles(numbers: numbers)
    return pebbles.pebbleCount(after: 75)
  }

  class Pebbles {
    var numbers: [Int]
    var cache: [Int: Int] = [:]

    init(numbers: [Int]) { self.numbers = numbers }

    func pebbleCount(after times: Int) -> Int {
      return numbers.map {
        process($0, times: times, count: 0)
      }.reduce(0, +)
    }

    func process(_ number: Int, times: Int, count: Int) -> Int {
      let cacheKey = number < 10000 ? (times | (number << 16)) : 0

      if cacheKey != 0, let result = cache[cacheKey] {
        return result + count
      }

      let result = processImpl(number, times: times, count: 0)

      if cacheKey != 0 {
        cache[cacheKey] = result
      }

      return result + count
    }

    func processImpl(_ number: Int, times: Int, count: Int) -> Int {
      if times == 0 { return count + 1 }

      if number == 0 {
        return process(1, times: times - 1, count: count)
      }

      let divider = number.splitDivider
      if divider == 0 {
        return process(2024 * number, times: times - 1, count: count)
      }

      let (q, r) = number.quotientAndRemainder(dividingBy: divider)
      let rCount = process(r, times: times - 1, count: count)
      return process(q, times: times - 1, count: rCount)
    }
  }
}

extension Int {

  var splitDivider: Int {
    if self < 10000 { // 11
      if self >= 1000       { return 100 }              // 4
      if self >= 100        { return 0 }                // 3
      if self >= 10         { return 10 }               // 2
      return 0                                          // 1
    }

    if self < 10000000000 { // 11
      if self >= 1000000000 { return 100000 }           // 10
      if self >= 100000000  { return 0 }                // 9
      if self >= 10000000   { return 10000 }            // 8
      if self >= 1000000    { return 0 }                // 7
      if self >= 100000     { return 1000 }             // 6
      return 0                                          // 1
    }

    if self < 100000000000        { return 0 }          // 11
    if self < 1000000000000       { return 1000000 }    // 12
    if self < 10000000000000      { return 0 }          // 13
    if self < 100000000000000     { return 10000000 }   // 14
    if self < 1000000000000000    { return 0 }          // 15
    if self < 10000000000000000   { return 100000000 }  // 16
    if self < 100000000000000000  { return 0 }          // 17
    if self < 1000000000000000000 { return 1000000000 } // 18
    fatalError()
  }
}
