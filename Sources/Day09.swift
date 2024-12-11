import Algorithms

/// Disk Fragmenter
/// https://adventofcode.com/2024/day/9
struct Day09: AdventDay {
  static let testData = """
    2333133121414131402
    """

  static var expectedTestResult1:   String { "1928" }
  static var expectedProperResult1: String { "6446899523367" }
  static var expectedTestResult2:   String { "2858" }
  // test disabled due to excessive runtime
  static var expectedProperResult2: String { "unknown" } // { "6478232739671" }

  var data: String

  var spans: [(id: Int?, count: Int)] {
    data.utf8
      .map { Int($0) - 48 }
      .filter { $0 >= 0 }
      .enumerated()
      .map { ($0.isMultiple(of: 2) ? $0 / 2 : nil, $1) }
  }

  func part1() -> Any {
    var blocks = spans
      .flatMap { id, count in Array(repeating: id, count: count) }
    let usedBlockCount = blocks.count(where: { $0 != nil })

    var backBlocks = blocks.reversed().compactMap(\.self).makeIterator()
    for index in blocks.indices where blocks[index] == nil {
      if index >= usedBlockCount { break }
      blocks[index] = backBlocks.next()
    }
    return blocks
      .prefix(usedBlockCount)
      .enumerated()
      .map { $0 * $1! }
      .reduce(0, +)
  }

  func part2() -> Any {
    var files: [(id: Int, range: Range<Int>)] = []
    var gaps: [Range<Int>] = []

    var index = 0
    for span in spans {
      defer { index += span.count }
      let range = index ..< index + span.count
      if let id = span.id {
        files.append((id, range))
      } else if range.isEmpty == false {
        gaps.append(range)
      }
    }

    func repairGaps() {
      for idx in gaps.indices.dropLast() {
        if gaps[idx].upperBound == gaps[idx + 1].lowerBound {
          gaps[idx] = gaps[idx].lowerBound ..< gaps[idx].lowerBound
          gaps[idx + 1] = gaps[idx].lowerBound ..< gaps[idx + 1].upperBound
        }
      }
    }

    func moveFile(at fileIndex: Int, toGapAt gapIndex: Int) {
      let fileRange = files[fileIndex].range
      let gapRange = gaps[gapIndex]

      files[fileIndex].range = gapRange.lowerBound ..< gapRange.lowerBound + fileRange.count
      gaps[gapIndex] = gapRange.lowerBound + fileRange.count ..< gapRange.upperBound

      let idx = gaps.firstIndex(where: { $0.lowerBound > fileRange.lowerBound }) ?? gaps.endIndex
      gaps.insert(fileRange, at: idx)
      repairGaps()
    }

    for fileIndex in files.indices.reversed() {
      let fileRange = files[fileIndex].range
      guard let gapIndex = gaps.firstIndex(where: { $0.count >= fileRange.count }) else { continue }
      guard gaps[gapIndex].lowerBound < fileRange.lowerBound else { continue }

      moveFile(at: fileIndex, toGapAt: gapIndex)
    }

    return files
      .map { span in span.range.map { span.id * $0 }.reduce(0, +) }
      .reduce(0, +)
  }

    func part2_alt() -> Any {
      var files: [Int: Range<Int>] = [:]
      var index = 0
      for span in spans {
        defer { index += span.count }
        if let id = span.id {
          files[id] = index ..< index + span.count
        }
      }

      var blocks = spans
        .flatMap { id, count in Array(repeating: id, count: count) }

      func firstGap(thatFits count: Int, notAfter filePos: Int) -> Int? {
        var searchPos = blocks.startIndex
        while let gapStart = blocks[searchPos...].firstIndex(of: nil), gapStart < filePos {
          let gapEnd = blocks[gapStart...].firstIndex(where: { $0 != nil }) ?? blocks.endIndex
          if gapEnd - gapStart >= count {
            return gapStart
          }
          searchPos = gapEnd
        }
        return nil
      }

      for id in (0 ..< files.count).reversed() {
        let file = files[id]!
        if let gapPos = firstGap(thatFits: file.count, notAfter: file.lowerBound) {
          let newRange = gapPos ..< gapPos + file.count
          for p in file { blocks[p] = nil }
          for p in newRange { blocks[p] = id }
          files[id] = newRange
        }
      }

      return blocks
        .enumerated()
        .compactMap { $0 * ($1 ?? 0) }
        .reduce(0, +)
    }

}
