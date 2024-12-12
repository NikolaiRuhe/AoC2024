import Foundation

/// Two dimensional integer coordinate.
struct Coord: Hashable, Comparable, CustomStringConvertible {
  var storage: (Int32, Int32)

  init(row: Int, col: Int) { self.storage = (Int32(row), Int32(col)) }

  var row: Int {
    get { Int(storage.0) }
    set { storage.0 = Int32(newValue) }
  }

  var col: Int {
    get { Int(storage.1) }
    set { storage.1 = Int32(newValue) }
  }

  var transposed: Coord { Self(row: col, col: row) }
  var n: Coord { Self(row: row - 1, col: col) }
  var s: Coord { Self(row: row + 1, col: col) }
  var w: Coord { Self(row: row, col: col - 1) }
  var e: Coord { Self(row: row, col: col + 1) }

  var description: String { "\(row)|\(col)" }

  func hash(into hasher: inout Hasher) { hasher.combine(storage.0); hasher.combine(storage.1) }
  static func == (lhs: Coord, rhs: Coord) -> Bool { lhs.storage == rhs.storage }
  static func < (lhs: Coord, rhs: Coord) -> Bool { lhs.storage < rhs.storage }

  prefix static func - (operand: Self) -> Self { Self(row: -operand.row, col: -operand.col) }
  mutating func negate() { self = -self }
  static func + (lhs: Coord, rhs: Coord) -> Coord { Coord(row: lhs.row + rhs.row, col: lhs.col + rhs.col) }
  static func += (lhs: inout Coord, rhs: Coord) { lhs.row = lhs.row + rhs.row; lhs.col = lhs.col + rhs.col }
  static func - (lhs: Coord, rhs: Coord) -> Coord { Coord(row: lhs.row - rhs.row, col: lhs.col - rhs.col) }
  static func -= (lhs: inout Coord, rhs: Coord) { lhs.row = lhs.row - rhs.row; lhs.col = lhs.col - rhs.col }
  static func + (lhs: Coord, rhs: Direction) -> Coord { lhs + rhs.offset }
  static func += (lhs: inout Coord, rhs: Direction) { lhs += rhs.offset }

  static var zero: Self { .init(row: 0, col: 0) }
}

enum Direction {
  case n, s, e, w
  var offset: Coord {
    switch self {
    case .n: Coord(row: -1, col:  0)
    case .s: Coord(row:  1, col:  0)
    case .e: Coord(row:  0, col:  1)
    case .w: Coord(row:  0, col: -1)
    }
  }
  var cw: Direction {
    switch self {
    case .n: .e
    case .e: .s
    case .s: .w
    case .w: .n
    }
  }
  var ccw: Direction {
    switch self {
    case .n: .w
    case .e: .n
    case .s: .e
    case .w: .s
    }
  }
  var opposite: Direction {
    switch self {
    case .n: .s
    case .e: .w
    case .s: .n
    case .w: .e
    }
  }
}

extension RandomAccessCollection where Self: MutableCollection, Element: RandomAccessCollection & MutableCollection, Index == Int, Element.Index == Int {
  subscript(_ coord: Coord) -> Element.Element {
    get { self[coord.row][coord.col] }
    set { self[coord.row][coord.col]  = newValue }
  }

  var dimensions: Coord { .init(row: count, col: first?.count ?? 0) }
  var rowIndices: Range<Int> { startIndex ..< endIndex }
  var colIndices: Range<Int> { 0 ..< (first?.count ?? 0) }

  var coordinates: some Sequence<Coord> {
    rowIndices.lazy.flatMap { row in
      colIndices.map { col in Coord(row: row, col: col) }
    }
  }

  var transposed: [[Element.Element]] {
    if isEmpty { return [] }
    let vertical = indices
    let horizontal = self[0].indices
    precondition(allSatisfy { $0.count == horizontal.count })

    return horizontal.map { h in vertical.map { v in self[v][h] } }
  }
}

extension StringProtocol {
  public subscript(_ position: Int) -> Character {
    get { self[index(startIndex, offsetBy: position)] }
  }
}


extension RandomAccessCollection where Self: MutableCollection, Element: StringProtocol, Index == Int {
  subscript(_ coord: Coord) -> Character {
    get { self[coord.row][coord.col] }
  }

  var rowIndices: Range<Int> { startIndex ..< endIndex }
  var colIndices: Range<Int> { 0 ..< (first?.count ?? 0) }

  var coordinates: some Sequence<Coord> {
    rowIndices.lazy.flatMap { row in
      colIndices.map { col in Coord(row: row, col: col) }
    }
  }

  var transposed: [String] {
    if isEmpty { return [] }
    let vertical = indices
    let horizontal = self[0].indices
    precondition(allSatisfy { $0.count == horizontal.count })

    return horizontal.map { h in String(vertical.map { v in self[v][h] }) }
  }
}

extension Sequence {
  func peek(_ body: (Self) -> Void) -> Self {
    body(self)
    return self
  }
}
