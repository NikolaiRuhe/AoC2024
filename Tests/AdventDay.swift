import Testing
@testable import AdventOfCode


extension AdventDay {
  static var isTest1Disabled:   Bool { expectedTestResult1   == "unknown" }
  static var isProper1Disabled: Bool { expectedProperResult1 == "unknown" || !hasData }
  static var isTest2Disabled:   Bool { expectedTestResult2   == "unknown" }
  static var isProper2Disabled: Bool { expectedProperResult2 == "unknown" || !hasData }

  func part1TestResult() async throws -> String {
    let day = Self(data: Self.testData)
    return String(describing: try await (day as any AdventDay).part1())
  }

  func part1ProperResult() async throws -> String {
    let day = Self() as any AdventDay
    return String(describing: try await (day as any AdventDay).part1())
  }

  func part2TestResult() async throws -> String {
    let day = Self(data: Self.testData)
    return String(describing: try await (day as any AdventDay).part2())
  }

  func part2ProperResult() async throws -> String {
    let day = Self()
    return String(describing: try await (day as any AdventDay).part2())
  }
}

protocol AdventTestDay {
  associatedtype TestDay: AdventDay
}

extension AdventTestDay {
  static var isTest1Disabled:   Bool { TestDay.expectedTestResult1   == "unknown" }
  static var isProper1Disabled: Bool { TestDay.expectedProperResult1 == "unknown" || !TestDay.hasData }
  static var isTest2Disabled:   Bool { TestDay.expectedTestResult2   == "unknown" }
  static var isProper2Disabled: Bool { TestDay.expectedProperResult2 == "unknown" || !TestDay.hasData }

  func part1TestResult() async throws -> String {
    let day = TestDay(data: TestDay.testData)
    return String(describing: try await (day as any AdventDay).part1())
  }

  func part1ProperResult() async throws -> String {
    let day = TestDay() as any AdventDay
    return String(describing: try await (day as any AdventDay).part1())
  }

  func part2TestResult() async throws -> String {
    let day = TestDay(data: TestDay.testData2)
    return String(describing: try await (day as any AdventDay).part2())
  }

  func part2ProperResult() async throws -> String {
    let day = TestDay()
    return String(describing: try await (day as any AdventDay).part2())
  }
}

