import Algorithms

// https://adventofcode.com/2024/day/12
struct Day12: AdventDay {
  static let testData = """
    RRRRIICCFF
    RRRRIICCCF
    VVRRRCCFFF
    VVRCCCJFFF
    VVVVCJJCFE
    VVIVCCJJEE
    VVIIICJJEE
    MIIIIIJJEE
    MIIISIJEEE
    MMMISSJEEE
    """

  static var expectedTestResult1:   String { "1930" }
  static var expectedProperResult1: String { "1473620" }
  static var expectedTestResult2:   String { "1206" }
  static var expectedProperResult2: String { "902620" }

  var garden: Garden
  init(data: String) { self.garden = Garden(data) }

  func part1() -> Any { garden.cost }
  func part2() -> Any { garden.bulkCost }

  struct Garden {
    var plots: [[UInt8]]

    init(_ data: String) {
      self.plots = data
        .split(separator: "\n")
        .map { $0.map { $0.asciiValue! } }
    }

    var cost: Int {
      calculateRegions().map(\.cost).reduce(0, +)
    }

    var bulkCost: Int {
      calculateRegions().map(\.bulkCost).reduce(0, +)
    }

    func calculateRegions() -> [Region] {
      var result: [Region] = []

      let dim = plots.dimensions
      var regionMap: [[Int]] = Array(repeating: [], count: dim.row + 1)

      for coord in plots.coordinates {
        let (n, w, s, e) = fences(at: coord)
        let fenceCount = (n ? 1 : 0) + (s ? 1 : 0) + (w ? 1 : 0) + (e ? 1 : 0)
        let newRegionIndex = makeOrFindRegion(at: coord, northFence: n, westFence: w)
        result[newRegionIndex].addPlot(at: coord, fence: fenceCount)
        regionMap[coord.row].append(newRegionIndex)
      }

      return result

      func makeOrFindRegion(at coord: Coord, northFence: Bool, westFence: Bool) -> Int {
        switch (northFence, westFence) {
        case (true, true):
          result.append(Region())
          return result.endIndex - 1
        case (false, true):
          return regionMap[coord.n]
        case (true, false):
          return regionMap[coord.w]
        case (false, false):
          return mergeRegions(at: regionMap[coord.n], and: regionMap[coord.w])
        }
      }

      func mergeRegions(at a: Int, and b: Int) -> Int {
        if a == b { return a }
        let (r1, r2) = (min(a, b), max(a, b))
        result[r1].merge(result.remove(at: r2))
        regionMap = regionMap.map { // fix previous indices
          $0.map { $0 == r2 ? r1 : ($0 > r2 ? $0 - 1 : $0) }
        }
        return r1
      }

      func fences(at coord: Coord) -> (n: Bool, w: Bool, s: Bool, e: Bool) {
        (n: coord.row == 0         || plots[coord.n] != plots[coord],
         w: coord.col == 0         || plots[coord.w] != plots[coord],
         s: coord.s.row == dim.row || plots[coord.s] != plots[coord],
         e: coord.e.col == dim.col || plots[coord.e] != plots[coord])
      }
    }
  }

  struct Region {
    var plots: Set<Coord> = []
    var perimeter: Int = 0
    var plotCount: Int { return plots.count }

    var cost: Int { perimeter * plotCount }
    var bulkCost: Int { sideCount * plotCount }

    var sideCount: Int {

      let (start, end) = plots.reduce(into: (min: plots.first!, max: plots.first!)) {
        $0.max.row = max($0.max.row, $1.row)
        $0.max.col = max($0.max.col, $1.col)
        $0.min.row = min($0.min.row, $1.row)
        $0.min.col = min($0.min.col, $1.col)
      }

      var result = 0

      var bitMap = SmallBitMap(height: (end - start).row + 2)
      for coord in plots { bitMap[coord - start] = true }
      var fenceMap = bitMap.shiftedDown ^ bitMap
      result += countOfSpansOfSetBits(zip(fenceMap.rows, bitMap.rows))

      bitMap = SmallBitMap(height: (end - start).col + 2)
      for coord in plots { let c = coord - start; bitMap[c.transposed] = true }
      fenceMap = bitMap.shiftedDown ^ bitMap
      result += countOfSpansOfSetBits(zip(fenceMap.rows, bitMap.rows))

      return result

      func countOfSpansOfSetBits(_ rows: some Sequence<(UInt64, UInt64)>) -> Int {
        var count = 0
        for (fenceBits, regionBits) in rows {
          var regionBits = regionBits
          var fenceBits = fenceBits
          while fenceBits != 0 {
            let zeros = fenceBits.trailingZeroBitCount
            fenceBits >>= zeros
            regionBits >>= zeros
            let ones = (~fenceBits).trailingZeroBitCount
            fenceBits >>= ones
            count += 1
            var p = (regionBits & 1) == 1
            for _ in 0 ..< ones {
              if p != ((regionBits & 1) == 1) {
                p.toggle()
                count += 1
              }
              regionBits >>= 1
            }
          }
        }
        return count
      }
    }

    mutating func addPlot(at coord: Coord, fence: Int) {
      plots.insert(coord)
      self.perimeter += fence
    }

    mutating func merge(_ other: Region) {
      plots.formUnion(other.plots)
      perimeter += other.perimeter
    }
  }

  struct SmallBitMap: CustomStringConvertible {
    var rows: [UInt64]
    init(rows: [UInt64]) { self.rows = rows }
    init(height: Int) { self.rows = Array(repeating: 0, count: height) }

    var shiftedDown: Self {
      var copy = self
      copy.rows.insert(0, at: 0)
      return copy
    }

    static func ^(left: Self, right: Self) -> Self {
      Self(rows: zip(left.rows, right.rows).map { $0 ^ $1 })
    }

    var description: String {
      rows.map { String($0, radix: 2) }.joined(separator: "\n")
    }

    var countOfSpansOfSetBits: Int {
      var count = 0
      for bits in rows {
        var bits = bits
        while bits != 0 {
          bits >>= bits.trailingZeroBitCount
          bits >>= (~bits).trailingZeroBitCount
          count += 1
        }
      }
      return count
    }

    subscript(_ coord: Coord) -> Bool {
      get { rows[coord.row] & (1 << coord.col) != 0 }
      set {
        if newValue {
          rows[coord.row] |= (1 << coord.col)
        } else {
          rows[coord.row] &= ~(1 << coord.col)
        }
      }
    }
  }
}
