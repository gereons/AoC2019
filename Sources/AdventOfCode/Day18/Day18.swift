//
// Advent of Code 2019
//
// https://adventofcode.com/2019/day/18
//

import AoCTools
import Darwin

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
    let entrances: [Point]
    let keys: [Key]
    let locks: Set<String>
    var paths = [Keys: Path]()

    var points: [Point: Tile] { grid.points }

    init(grid: Grid<Tile>) {
        self.grid = grid

        let entrances = grid.points.filter { $0.value == .entrance }.map { $0.key }
        let keys: [Key] = grid.points.compactMap { point, tile in
            guard case Tile.key(let letter) = tile else { return nil }
            return Key(letter: letter, point: point)
        }

        let locks: [String] = grid.points.compactMap { _, tile in
            guard case Tile.lock(let letter) = tile else { return nil }
            return letter
        }

        self.entrances = entrances
        self.keys = keys
        self.locks = Set(locks)

        let paths = findAllPaths(between: keys, entrances: entrances)
        self.paths = paths
    }

    private func findAllPaths(between keys: [Key], entrances: [Point]) -> [Keys: Path] {
        var result = [Keys: Path]()

        let entranceKeys = entrances.map { Key(letter: "@", point: $0) }
        for key1 in keys {
            for entrance in entranceKeys {
                let path = pathFrom(entrance, to: key1)
                if path.length > 0 {
                    result[Keys(from: entrance, to: key1)] = path
                }
            }
            for key2 in keys where key1 != key2 {
                let path = pathFrom(key1, to: key2)
                if path.length > 0 {
                    result[Keys(from: key1, to: key2)] = path
                }
            }
        }
        return result
    }

    private func pathFrom(_ from: Key, to: Key) -> Path {
        let pathfinder = AStarPathfinder(map: MazePathfinder(points: points))

        let path = pathfinder.shortestPath(from: from.point, to: to.point)
        var keysNeeded = Set<String>()
        var collectingKeys = Set<String>()
        for p in path {
            switch points[p] {
            case .lock(let letter): keysNeeded.insert(letter.lowercased())
            case .key(let letter): collectingKeys.insert(letter.lowercased())
            default: ()
            }
        }

        return Path(points: path, keysNeeded: keysNeeded, collectingKeys: collectingKeys)
    }

    private struct MemoKey: Hashable {
        let from: String
        let to: String
        let availableKeys: Set<String>
        let ownedKeys: Set<String>
    }

    private var memos = [MemoKey: Int]()

    func moveToNextKey(from: String,
                       availableKeys: Set<String>,
                       ownedKeys: Set<String>,
                       currentPositions: Set<Point>,
                       distance: Int
    ) -> Int {
        assert(availableKeys.intersection(ownedKeys).isEmpty)
        assert(availableKeys.count + ownedKeys.count == keys.count)
        assert(currentPositions.count == entrances.count)
        if availableKeys.isEmpty {
            return distance
        }

        let targets: [Keys: Path]
//        if entrances.count == 1 {
//            targets = paths.filter { keys, path in
//                !ownedKeys.contains(keys.to.letter)
//                    && keys.from.letter == from
//                    && path.keysNeeded.isSubset(of: ownedKeys)
//            }
//        } else {
//            assert(entrances.count == 4)
            targets = paths.filter { keys, path in
                currentPositions.contains(keys.from.point)
                && !path.collectingKeys.subtracting(ownedKeys).intersection(availableKeys).isEmpty
                && path.keysNeeded.isSubset(of: ownedKeys)
            }
//        }

        var nextDistance = Int.max
        for (keys, path) in targets {
            let nextAvailableKeys = availableKeys.subtracting(path.collectingKeys)
            let nextOwnedKeys = ownedKeys.union(path.collectingKeys)
            var nextPositions = currentPositions
            nextPositions.remove(keys.from.point)
            nextPositions.insert(keys.to.point)

            assert(from == keys.from.letter)
            let memoKey = MemoKey(from: from, to: keys.to.letter,
                                  availableKeys: nextAvailableKeys,
                                  ownedKeys: nextOwnedKeys)

            if let distance = memos[memoKey] {
                nextDistance = min(nextDistance, distance)
            } else {
                let distance = moveToNextKey(from: keys.to.letter,
                                             availableKeys: nextAvailableKeys,
                                             ownedKeys: nextOwnedKeys,
                                             currentPositions: nextPositions,
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
        let result = vault.moveToNextKey(from: "@",
                                         availableKeys: Set(allKeys),
                                         ownedKeys: [],
                                         currentPositions: Set(vault.entrances),
                                         distance: 0)
        return result
    }

    func part2() -> Int {
        let grid = checkEntrances(in: grid)
        let vault = Vault(grid: grid)
        let allKeys = vault.keys.map { $0.letter }
        let result = vault.moveToNextKey(from: "@",
                                         availableKeys: Set(allKeys),
                                         ownedKeys: [],
                                         currentPositions: Set(vault.entrances),
                                         distance: 0)

        return result
    }

    private func checkEntrances(in grid: Grid<Tile>) -> Grid<Tile> {
        let entrances = grid.points.filter { $0.value == .entrance }
        if entrances.count == 4 {
            return grid
        }
        assert(entrances.count == 1)
        var points = grid.points

        let entrance = entrances.first!.key
        points[entrance] = .wall
        for p in entrance.neighbors() {
            points[p] = .wall
        }
        for p in entrance.neighbors(adjacency: .diagonal) {
            points[p] = .entrance
        }
        return Grid(points: points)
    }
}
