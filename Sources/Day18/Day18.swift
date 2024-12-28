//
// Advent of Code 2019
//
// https://adventofcode.com/2019/day/18
//

import AoCTools
import Collections

private enum Tile: Drawable, Equatable {
    var draw: Character {
        switch self {
        case .wall: return "#"
        case .floor: return "."
        case .entrance: return "@"
        case .key(let ch), .lock(let ch):
            return ch
        }
    }

    static func value(for ch: Character) -> Tile {
        switch ch {
        case "#": return .wall
        case ".": return .floor
        case "@": return .entrance
        case "a"..."z": return .key(ch)
        case "A"..."Z": return .lock(ch)
        default: fatalError()
        }
    }

    case floor
    case wall
    case entrance
    case key(Character)
    case lock(Character)

    var key: Character? {
        switch self {
        case .key(let key): return key
        default: return nil
        }
    }

    var lock: Character? {
        switch self {
        case .lock(let lock): return lock
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
    let letter: Character
    let point: Point
}

private struct Keys: Hashable {
    let from: Key
    let to: Key
}

private struct Path: Hashable {
    let points: [Point]
    let keysNeeded: Set<Character>
    let collectingKeys: Set<Character>

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
        assert(paths.values.allSatisfy { $0.length > 0 })
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
        let pathfinder = AStarPathfinder(map: self)

        let path = pathfinder.shortestPath(from: from.point, to: to.point)
        var keysNeeded = Set<Character>()
        var collectingKeys = Set<Character>()

        for p in path {
            switch points[p] {
            case .lock(let letter): keysNeeded.insert(Character(letter.lowercased()))
            case .key(let letter): collectingKeys.insert(Character(letter.lowercased()))
            case .wall: fatalError()
            default: ()
            }
        }

        return Path(points: path, keysNeeded: keysNeeded, collectingKeys: collectingKeys)
    }
}

extension Vault: Pathfinding {
    func neighbors(of point: Point) -> [Point] {
        point.neighbors().filter { point in
            switch points[point] {
            case .none, .wall: return false
            case .floor, .entrance, .key, .lock: return true
            }
        }
    }
}

extension Vault {

    private struct MemoKey: Hashable {
        let points: Set<Point>
        let keys: Set<Character>
    }

    func minimumSteps(from: Set<Point>) -> Int {
        var seen = [MemoKey: Int]()
        return minimumSteps(from: from, haveKeys: [], seen: &seen)
    }

    private func minimumSteps(from: Set<Point>,
                              haveKeys: Set<Character>,
                              seen: inout [MemoKey: Int]
    ) -> Int {
        let state = MemoKey(points: from, keys: haveKeys)
        if let distance = seen[state] {
            return distance
        }

        let distances = findReachable(from: from, haveKeys).map {
            let at = $0.value.at
            let distance = $0.value.distance
            let cause = $0.value.cause
            return distance + minimumSteps(from: from - cause + at, haveKeys: haveKeys + $0.key, seen: &seen)
        }
        let answer = distances.min(by: <) ?? 0
        seen[state] = answer
        return answer
    }

    private struct ReachableKey {
        let at: Point
        let distance: Int
        let cause: Point
    }

    private func findReachable(from: Set<Point>, _ haveKeys: Set<Character>) -> [Character: ReachableKey] {
        let array = from
            .map { point in
                findReachableKeys(from: point, haveKeys: haveKeys).map {
                    ($0.key, ReachableKey(at: $0.value.point, distance: $0.value.distance, cause: point))
                }
            }
            .flatMap { $0 }
        return Dictionary(uniqueKeysWithValues: array)
    }

    private struct KeyDistance {
        let point: Point
        let distance: Int
    }

    private func findReachableKeys(from point: Point, haveKeys: Set<Character>) -> [Character: KeyDistance] {
        var queue = Heap<Point>()
        queue.insert(point)

        var distance = [point: 0]
        var keyDistance = [Character: KeyDistance]()

        while let next = queue.popMin() {
            next.neighbors()
                .filter { points[$0] != .wall }
                .filter { distance[$0] == nil }
                .forEach { point in
                    distance[point] = distance[next]! + 1

                    let lock = points[point]?.lock
                    let key = points[point]?.key
                    if lock == nil || haveKeys.contains(lock?.lowercased() ?? "") {
                        if let key = key, !haveKeys.contains(key) {
                            keyDistance[key] = KeyDistance(point: point, distance: distance[point]!)
                        } else {
                            queue.insert(point)
                        }
                    }
                }
        }
        return keyDistance
    }
}


final class Day18: AOCDay {
    private let grid: Grid<Tile>
    init(input: String) {
        grid = Grid.parse(input.components(separatedBy: "\n"))
    }

    func part1() -> Int {
        let vault = Vault(grid: grid)
        let distance = vault.minimumSteps(from: Set(vault.entrances))
        return distance
    }

    func part2() -> Int {
        let grid = checkEntrances(in: grid)
        let vault = Vault(grid: grid)
        let distance = vault.minimumSteps(from: Set(vault.entrances))
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
        for p in entrance.neighbors(adjacency: .ordinal) {
            points[p] = .entrance
        }
        return Grid(points: points)
    }
}
