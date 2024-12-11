import Algorithms

/// Guard Gallivant
/// https://adventofcode.com/2024/day/6
struct Day06: AdventDay {
  static let testData = """
    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...
    """

  static var expectedTestResult1:   String { "41" }
  static var expectedProperResult1: String { "5153" }
  static var expectedTestResult2:   String { "6" }
  // test disabled due to excessive runtime
  static var expectedProperResult2: String { "unknown" } // { "1711" }

  var data: String

  func part1() -> Any {
    var room = SparseGrid(data)
    return room.walkRoom() ?? 0
  }

  func part2() -> Any {
    var result = 0
    let room = SparseGrid(data)
    var copy = room
    _ = copy.walkRoom()
    for r in room.rows.indices {
      for c in room.cols.indices {
        if copy._guard.path[r][c] == 0 { continue }
        if room.rows[r].contains(c) { continue }
        if r == room._guard.row && c == room._guard.col { continue }
        var testRoom = room
        testRoom.rows[r].append(c)
        testRoom.rows[r].sort()
        testRoom.cols[c].append(r)
        testRoom.cols[c].sort()
        if testRoom.walkRoom() == nil { result += 1 }
      }
    }
    return result
  }
}


struct SparseGrid {
  var rows: [[Int]] = []
  var cols: [[Int]] = []
  var _guard = Guard()

  init(_ data: String) {
    for (r, line) in data.split(separator: "\n").enumerated() {
      if r == rows.count { rows.append([]) }
      for (c, char) in line.enumerated() {
        if c == cols.count { cols.append([]) }
        switch char {
        case ".": continue
        case "^":
          _guard.col = c
          _guard.row = r
        case "#":
          rows[r].append(c)
          cols[c].append(r)
        default: fatalError()
        }
      }
    }
    _guard.path = Array(repeating: Array(repeating: 0, count: cols.count), count: rows.count)
  }

  mutating func walkRoom() -> Int? {
    while true {
      guard move() else { return nil }
      guard isInside else {
        return _guard.path.reduce(0) { $0 + $1.count(where: { $0 != 0 }) }
      }
      _guard.direction = _guard.direction.next
    }
  }

  var isInside: Bool {
    guard _guard.col != 0 else { return false }
    guard _guard.row != 0 else { return false }
    guard _guard.col < cols.count - 1 else { return false }
    guard _guard.row < rows.count - 1 else { return false }
    return true
  }

  mutating func move() -> Bool {
    switch _guard.direction {
    case .n: _guard.move(toRow: (cols[_guard.col].last(where:  { $0 < _guard.row }) ?? -1) + 1)
    case .s: _guard.move(toRow: (cols[_guard.col].first(where: { $0 > _guard.row }) ?? rows.count) - 1)
    case .w: _guard.move(toCol: (rows[_guard.row].last(where:  { $0 < _guard.col }) ?? -1) + 1)
    case .e: _guard.move(toCol: (rows[_guard.row].first(where: { $0 > _guard.col }) ?? cols.count) - 1)
    }
  }

  struct Guard {
    var col: Int = 0
    var row: Int = 0
    var direction: Direction = .n
    var path: [[UInt8]] = []

    mutating func move(toCol newCol: Int) -> Bool {
      defer { col = newCol }
      for col in min(newCol, col) ... max(newCol, col) {
        if path[row][col].visit(direction.rawValue) { return false }
      }
      return true
    }

    mutating func move(toRow newRow: Int) -> Bool {
      defer { row = newRow }
      for row in min(newRow, row) ... max(newRow, row) {
        if path[row][col].visit(direction.rawValue) { return false }
      }
      return true
    }
  }

  enum Direction: UInt8 {
    case n = 1, e = 2, s = 4, w = 8
    var next: Self {
      switch self  {
      case .n: .e
      case .e: .s
      case .s: .w
      case .w: .n
      }
    }
  }
}

extension UInt8 {
  fileprivate mutating func visit(_ other: UInt8) -> Bool {
    defer { self |= other }
    return self & other != 0
  }
}
