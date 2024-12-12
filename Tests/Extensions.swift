import Testing
@testable import AdventOfCode


struct ExtensionTests {
  @Test func transposedArray() async throws {
    let sut    = [[1, 2, 3], [4, 5, 6]]
    let expect = [[1, 4], [2, 5], [3, 6]]
    #expect(sut.transposed == expect)
  }

  @Test func transposed2() async throws {
    let sut    = ["ABC", "DEF"]
    let expect = ["AD", "BE", "CF"]
    #expect(sut.transposed == expect)
  }

  @Test func transposed3() async throws {
    let string = """
      ABC
      DEF
      """
    let sut = string.split(separator: "\n").map { Array($0.utf8) }
    let expect: [[UInt8]] = [[65, 68], [66, 69], [67, 70]]
    #expect(sut.transposed == expect)
  }

  @Test func coordOperators() async throws {
    var sut = Coord(row: 42, col: 12)
    #expect(sut.row == 42)
    sut = -sut
    #expect(sut.row == -42)
  }
}
