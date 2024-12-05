import Algorithms

struct Day05: AdventDay {
  var order: [String: Bool]
  var updates: [[Int]]

  init(data: String) {
    let parts = data.split(separator: "\n\n").map { $0.split(separator: "\n") }

    self.order = Dictionary(uniqueKeysWithValues: parts[0].map {
      $0.split(separator: "|").map { Int($0)! }
    }.flatMap { e in
      [("\(e[0])_\(e[1])", true), ("\(e[1])_\(e[0])", false)]
    })

    self.updates = parts[1].map { $0.split(separator: ",").map { Int($0)! } }
  }

  func sortOrder(a: Int, b: Int) -> Bool { order["\(a)_\(b)"] ?? false }

  func part1() -> Any {
    updates
      .filter { $0.sorted(by: sortOrder) == $0 }
      .map { $0[$0.count / 2] }
      .reduce(0, +)
  }

  func part2() -> Any {
    updates
      .filter { $0.sorted(by: sortOrder) != $0 }
      .map { $0.sorted(by: sortOrder)[$0.count / 2] }
      .reduce(0, +)
  }
}
