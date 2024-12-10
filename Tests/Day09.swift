import Testing
@testable import AdventOfCode


struct Day09Tests: AdventTestDay {
  typealias TestDay = Day09

  @Test(.disabled(if: isTest1Disabled))
  func testPart1() async throws {
    let result = try await part1TestResult()
    #expect(result == TestDay.expectedTestResult1)
  }

  @Test(.disabled(if: isProper1Disabled))
  func properPart1() async throws {
    let result = try await part1ProperResult()
    #expect(result == TestDay.expectedProperResult1)
  }

  @Test(.disabled(if: isTest2Disabled))
  func testPart2() async throws {
    let result = try await part2TestResult()
    #expect(result == TestDay.expectedTestResult2)
  }

  @Test(.disabled(if: isProper2Disabled))
  func properPart2() async throws {
    let result = try await part2ProperResult()
    #expect(result == TestDay.expectedProperResult2)
  }
}
