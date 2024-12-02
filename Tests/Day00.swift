import Testing
@testable import AdventOfCode


struct Day00Tests {
  typealias TestDay = Day00

  let testData = """
    1000
    2000
    3000
    
    4000
    
    5000
    6000
    
    7000
    8000
    9000
    
    10000
    
    """

  @Test func testPart1() async throws {
    let challenge = TestDay(data: testData)
    #expect(String(describing: challenge.part1()) == "6000")
  }

  @Test func testPart1_originalData() async throws {
    let challenge = TestDay()
    #expect(String(describing: challenge.part1()) == "47524")
  }

  @Test func testPart2() async throws {
    let challenge = TestDay(data: testData)
    #expect(String(describing: challenge.part2()) == "32000")
  }

  @Test func testPart2_originalData() async throws {
    let challenge = TestDay()
    #expect(String(describing: challenge.part2()) == "3320550")
  }
}
