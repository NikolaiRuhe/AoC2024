import Algorithms

// Warehouse Woes
// https://adventofcode.com/2024/day/15
struct Day15: AdventDay {
  static let testData = """
    ##########
    #..O..O.O#
    #......O.#
    #.OO..O.O#
    #..O@..O.#
    #O#..O...#
    #O..O..O.#
    #.OO.O.OO#
    #....O...#
    ##########

    <vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
    vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
    ><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
    <<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
    ^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
    ^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
    >^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
    <><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
    ^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
    v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
    """

  static var expectedTestResult1:   String { "10092" }
  static var expectedProperResult1: String { "1430439" }
  static var expectedTestResult2:   String { "9021" }
  static var expectedProperResult2: String { "1458740" }

  var route: [Step]
  var map: Map

  init(data: String) {
    let parts = data.split(separator: "\n\n")
    self.map = Map(parts[0].split(separator: "\n"))
    self.route = parts[1].compactMap { Step($0) }
  }

  func part1() -> Any {
    var map = self.map
    var pos = map.startPos
    for step in route {
      pos = map.move(from: pos, step: step)
    }

    return map.sumOfGPS
  }

  func part2() -> Any {
    var map = Map(wideMapFrom: self.map)
    var pos = map.startPos
    for step in route {
      pos = map.move(from: pos, step: step)
    }

    return map.sumOfGPS
  }

  struct Map {
    var rows: [[Cell]]
    var startPos: Coord

    init(_ lines: [Substring]) {
      self.rows = lines.map { $0.map { Cell($0) } }
      let row = lines.firstIndex { $0.contains("@") }!
      let col = lines[row].enumerated().first(where: { $0.1 == "@" })!.0
      self.startPos = Coord(row: row, col: col)
    }

    init(wideMapFrom map: Map) {
      self.rows = map.rows.map { $0.flatMap {
        $0 != .crate ? [ $0, $0 ] : [ .wHalfCrate, .eHalfCrate ]
      }}
      self.startPos = map.startPos
      self.startPos.col *= 2
    }

    mutating func move(from pos: Coord, step: Step) -> Coord {
//      print("robot at: \(pos), trying \(step)")
//      printMap(robotAt: pos, facing: step)
      var crateCoords = Set<Coord>()
      guard tryMove(from: pos) else {
//        print("blocked: \(step)")
        return pos
      }
//      print("moving: \(step)")

      let sortedCrates = crateCoords.sorted() { a, b in
        switch step {
        case .n: return a.row < b.row
        case .s: return a.row > b.row
        case .w: return a.col < b.col
        case .e: return a.col > b.col
        }
      }

      for coord in sortedCrates {
        let isWide = rows[coord] == .wHalfCrate
        assert(isWide || rows[coord] == .crate)
        rows[coord]   = .empty
        if isWide { rows[coord.e] = .empty }
        rows[coord.step(step)]   = isWide ? .wHalfCrate : .crate
        if isWide { rows[coord.step(step).e] = .eHalfCrate }
      }

      return pos.step(step)

      func tryMove(from pos: Coord) -> Bool {
        let nextStep = pos.step(step)

        return switch rows[nextStep] {
        case .empty:      true
        case .wall:       false
        case .crate:      shiftCrate(at: nextStep)
        case .wHalfCrate: shiftWideCrate(w: nextStep, e: nextStep.e)
        case .eHalfCrate: shiftWideCrate(w: nextStep.w, e: nextStep)
        }

        func shiftCrate(at pos: Coord) -> Bool {
          guard tryMove(from: pos) else { return false }
          crateCoords.insert(pos)
          return true
        }

        func shiftWideCrate(w: Coord, e: Coord) -> Bool {
          switch step {
          case .n, .s:
            guard tryMove(from: w) else { return false }
            guard tryMove(from: e) else { return false }
          case .w:
            guard tryMove(from: w) else { return false }
          case .e:
            guard tryMove(from: e) else { return false }
          }
          crateCoords.insert(w)
          return true
        }
      }
    }

    var sumOfGPS: Int {
      rows
        .coordinates
        .filter { rows[$0] == .crate || rows[$0] == .wHalfCrate }
        .map { $0.row * 100 + $0.col }
        .reduce(0, +)
    }

    func printMap(robotAt pos: Coord, facing: Step) {
      let map = rows.map {
        String($0.map { cell in cell.char })
      }.joined(separator: "\n")

      let o = pos.row * (1 + rows[0].count) + pos.col
      print(map.prefix(o), facing.char, map.dropFirst(o + 1), separator: "")
    }
  }

  enum Cell {
    init(_ character: Character) {
      switch character {
      case ".", "@": self = .empty
      case "#": self = .wall
      case "O": self = .crate
      default: fatalError()
      }
    }
    case empty, wall, crate, wHalfCrate, eHalfCrate
    var char: Character {
      switch self {
      case .empty: "."
      case .wall:  "#"
      case .crate: "O"
      case .wHalfCrate: "["
      case .eHalfCrate: "]"
      }
    }
  }

  enum Step {
    case n, s, e, w
    init?(_ character: Character) {
      switch character {
      case "^": self = .n
      case "<": self = .w
      case ">": self = .e
      case "v": self = .s
      default: return nil
      }
    }
    var isVertical: Bool { self == .n || self == .s }
    var char: Character {
      switch self {
      case .n: "^"
      case .s: "v"
      case .e: ">"
      case .w: "<"
      }
    }
  }
}


extension Coord {
  func step(_ step: Day15.Step) -> Coord {
    switch step {
    case .n: n
    case .s: s
    case .e: e
    case .w: w
    }
  }
}
