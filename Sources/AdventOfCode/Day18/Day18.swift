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

private struct Path: Hashable {
    let points: [Point]
    let keysNeeded: Set<String>
    let collectingKeys: Set<String>

    var length: Int { points.count }
}

private class Vault {
    let grid: Grid<Tile>
    let entrances: [Point]
    let keys: [Key]
    var paths = [Keys: Path]()

    var points: [Point: Tile] { grid.points }

    init(grid: Grid<Tile>) {
        self.grid = grid

        let entrances = grid.points.filter { $0.value == .entrance }.map { $0.key }
        self.entrances = entrances

        let keys: [Key] = grid.points.compactMap { point, tile in
            guard case Tile.key(let letter) = tile else { return nil }
            return Key(letter: letter, point: point)
        }
        self.keys = keys

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
        let from: Point
        let to: Point
        let availableKeys: Set<String>
        let ownedKeys: Set<String>
    }

    private var memos = [MemoKey: Int]()

    func moveToNextKey(from positions: Set<Point>,
                       availableKeys: Set<String>,
                       ownedKeys: Set<String>,
                       visited: Set<Path>,
                       distance: Int
    ) -> Int {
        assert(positions.count == entrances.count)
        assert(availableKeys.intersection(ownedKeys).isEmpty)
        assert(availableKeys.count + ownedKeys.count == keys.count)

        if availableKeys.isEmpty {
            return distance
        }

        let targets = paths.filter { keys, path in
            positions.contains(keys.from.point)
            && !visited.contains(path)
            && path.keysNeeded.isSubset(of: ownedKeys)
            && !availableKeys.contains(keys.from.letter)
            && availableKeys.contains(keys.to.letter)
        }
        assert(!targets.isEmpty)

        var nextDistance = Int.max
        for (keys, path) in targets {
            assert(path.keysNeeded.isSubset(of: ownedKeys))
            assert(!availableKeys.contains(keys.from.letter))
            assert(availableKeys.contains(keys.to.letter))
            if keys.from.letter != "@" {
                assert(ownedKeys.contains(keys.from.letter))
            }
            assert(!ownedKeys.contains(keys.to.letter))

            let nextAvailableKeys = availableKeys.subtracting(path.collectingKeys)
            let nextOwnedKeys = ownedKeys.union(path.collectingKeys)
            let nextPositions = positions.subtracting([keys.from.point]).union([keys.to.point])
            let nextVisited = visited.union([path])

            assert(nextOwnedKeys.contains(keys.to.letter))
            assert(!nextAvailableKeys.contains(keys.to.letter))

            let memoKey = MemoKey(from: keys.from.point,
                                  to: keys.to.point,
                                  availableKeys: nextAvailableKeys,
                                  ownedKeys: nextOwnedKeys)

            if let distance = memos[memoKey] {
                nextDistance = min(nextDistance, distance)
            } else {
                let distance = moveToNextKey(from: nextPositions,
                                             availableKeys: nextAvailableKeys,
                                             ownedKeys: nextOwnedKeys,
                                             visited: nextVisited,
                                             distance: path.length)
                memos[memoKey] = distance
                nextDistance = min(nextDistance, distance)
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
        let distance = vault.moveToNextKey(from: Set(vault.entrances),
                                           availableKeys: Set(allKeys),
                                           ownedKeys: [],
                                           visited: [],
                                           distance: 0)
        return distance
    }

    func part2() -> Int {
        let grid = checkEntrances(in: grid)
        let vault = Vault(grid: grid)
        let allKeys = vault.keys.map { $0.letter }
        let distance = vault.moveToNextKey(from: Set(vault.entrances),
                                           availableKeys: Set(allKeys),
                                           ownedKeys: [],
                                           visited: [],
                                           distance: 0)
        return distance
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
