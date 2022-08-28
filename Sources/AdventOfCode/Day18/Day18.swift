//
// Advent of Code 2019
//
// https://adventofcode.com/2019/day/18
//

import AoCTools

private enum Tile: Drawable, Equatable {
    var draw: String {
        switch self {
        case .wall: return "#"
        case .floor: return "."
        case .entrance: return "@"
        case .key(let str), .lock(let str):
            return str
        }
    }

    static func value(for str: String) -> Tile {
        switch str {
        case "#": return .wall
        case ".": return .floor
        case "@": return .entrance
        case "a"..."z": return .key(str)
        case "A"..."Z": return .lock(str)
        default: fatalError()
        }
    }

    case floor
    case wall
    case entrance
    case key(String)
    case lock(String)

    var key: String? {
        switch self {
        case .key(let key): return key
        default: return nil
        }
    }

    static func == (lhs: Tile, rhs: Tile) -> Bool {
        switch (lhs, rhs) {
        case (.wall, .wall): return true
        case (.floor, .floor): return true
        case (.entrance, .entrance): return true
        case (.key(let k1), .key(let k2)): return k1 == k2
        case (.lock(let l1), .lock(let l2)): return l1 == l2
        default: return false
        }
    }
}

private struct Key: Hashable {
    let letter: String
    let point: Point

    static let none = Key(letter: "", point: .zero)
}

private struct Keys: Hashable {
    let from: Key
    let to: Key
}

private struct Path {
    let points: [Point]
    let keysNeeded: Set<String>
    let collectingKeys: Set<String>

    var length: Int { points.count }
}

private class Vault {
    let grid: Grid<Tile>
    let entrance: Point
    let keys: [Key]
    var paths = [Keys: Path]()

    var points: [Point: Tile] { grid.points }

    init(grid: Grid<Tile>) {
        self.grid = grid

        let entrance = grid.points.first { $0.value == .entrance }!.key
        let keys: [Key] = grid.points.compactMap { point, tile in
            guard case Tile.key(let letter) = tile else { return nil }
            return Key(letter: letter, point: point)
        }

        self.entrance = entrance
        self.keys = keys

        let paths = findAllPaths(between: keys, entrance: entrance)
        self.paths = paths
    }

    private func findAllPaths(between keys: [Key], entrance: Point) -> [Keys: Path] {
        var result = [Keys: Path]()

        let entranceKey = Key(letter: "@", point: entrance)
        for key1 in keys {
            result[Keys(from: entranceKey, to: key1)] = pathFrom(entranceKey, to: key1)
            for key2 in keys where key1 != key2 {
                result[Keys(from: key1, to: key2)] = pathFrom(key1, to: key2)
            }
        }
        return result
    }

    private func pathFrom(_ from: Key, to: Key) -> Path {
        let pathfinder = AStarPathfinder(map: MazePathfinder(points: points))

        let path = pathfinder.shortestPathFrom(from.point, to: to.point)
        var keysNeeded = Set<String>()
        var collectingKeys = Set<String>()
        for p in path {
            switch points[p] {
            case .lock(let letter): keysNeeded.insert(letter.lowercased())
            case .key(let letter): collectingKeys.insert(letter.lowercased())
            default: ()
            }
        }

        return Path(points: Array(path.dropFirst()), keysNeeded: keysNeeded, collectingKeys: collectingKeys)
    }

    private struct MemoKey: Hashable {
        let from: String
        let to: String
        let availableKeys: Set<String>
        let ownedKeys: Set<String>
    }

    private var memos = [MemoKey: Int]()
    func moveToNextKey(from: Key,
                       availableKeys: Set<String>,
                       ownedKeys: Set<String>,
                       distance: Int
    ) -> Int {
        assert(availableKeys.intersection(ownedKeys).isEmpty)
        assert(availableKeys.count + ownedKeys.count == keys.count)
        if availableKeys.isEmpty {
            return distance
        }

        let targets = paths.filter { keys, path in
            !ownedKeys.contains(keys.to.letter)
                && keys.from.letter == from.letter
                && path.keysNeeded.isSubset(of: ownedKeys)
        }

        var nextDistance = Int.max
        for (keys, path) in targets {
            let nextAvailableKeys = availableKeys.subtracting(path.collectingKeys)
            let nextOwnedKeys = ownedKeys.union(path.collectingKeys)

            let memoKey = MemoKey(from: from.letter, to: keys.to.letter,
                                  availableKeys: nextAvailableKeys,
                                  ownedKeys: nextOwnedKeys)

            if let distance = memos[memoKey] {
                nextDistance = min(nextDistance, distance)
            } else {
                let distance = moveToNextKey(from: keys.to,
                                             availableKeys: nextAvailableKeys,
                                             ownedKeys: nextOwnedKeys,
                                             distance: path.length)
                nextDistance = min(nextDistance, distance)
                memos[memoKey] = distance
            }
        }

        return distance + nextDistance
    }
}

private struct MazePathfinder: Pathfinding {
    let points: [Point: Tile]

    init(points: [Point: Tile]) {
        self.points = points
    }

    func neighbors(for point: Point) -> [Point] {
        point.neighbors().filter { point in
            switch points[point] {
            case .none, .wall: return false
            case .floor, .entrance, .key, .lock: return true
            }
        }
    }
}

final class Day18: AOCDay {
    private let grid: Grid<Tile>
    init(rawInput: String? = nil) {
        let input = rawInput ?? Self.rawInput
        grid = Grid.parse(input.components(separatedBy: "\n"))
    }

    func part1() -> Int {
        let vault = Vault(grid: grid)

        let allKeys = vault.keys.map { $0.letter }
        let result = vault.moveToNextKey(from: Key(letter: "@", point: vault.entrance),
                                         availableKeys: Set(allKeys),
                                         ownedKeys: [],
                                         distance: 0)
        return result
    }

    func part2() -> Int {
        return 0
    }
}
