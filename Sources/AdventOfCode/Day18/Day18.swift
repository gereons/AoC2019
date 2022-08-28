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

private struct Key {
    let letter: String
    let point: Point
    let distance: Int
}

private struct Memo: Hashable {
    let point: Point
    let key: String
    let ownedKeys: Set<String>
}

private class Vault {
    let grid: Grid<Tile>
    let entrance: Point
    let keys: [Point: Tile]

    var points: [Point: Tile] {
        grid.points
    }

    var visited = [Memo: [Point]]()

    init(grid: Grid<Tile>) {
        self.grid = grid

        entrance = grid.points.first { $0.value == .entrance }!.key
        keys = grid.points.filter { point, tile in
            if case Tile.key = tile { return true }
            return false
        }
    }

    func moveToNextKey(from point: Point, to key: String,
                       availableKeys: Set<String>,
                       ownedKeys: Set<String>,
                       distanceSoFar: Int,
                       result: inout Int
    ) {
        if availableKeys.isEmpty {
            if distanceSoFar < result {
                print(distanceSoFar)
                result = distanceSoFar
            }
            return
        }

        let vaultPathfinder = VaultPathfinder(vault: self, ownedKeys: ownedKeys)
        let reachableKeys = vaultPathfinder.reachableKeys(from: point, visited: &visited)
        // print(reachableKeys.map { $0.letter })
        for targetKey in reachableKeys {
            // print("move to", key.letter)
            if distanceSoFar + targetKey.distance >= result {
                continue
            }

            moveToNextKey(from: targetKey.point, to: targetKey.letter,
                          availableKeys: availableKeys.subtracting([key]),
                          ownedKeys: ownedKeys.union([key]),
                          distanceSoFar: distanceSoFar + targetKey.distance,
                          result: &result)
        }
    }
}

private struct VaultPathfinder: Pathfinding {
    let points: [Point: Tile]
    let keys: [Point: Tile]
    let ownedKeys: Set<String>

    init(vault: Vault, ownedKeys: Set<String>) {
        self.points = vault.points
        self.keys = vault.keys
        self.ownedKeys = ownedKeys
    }

    func neighbors(for point: Point) -> [Point] {
        point.neighbors().filter { point in
            switch points[point] {
            case .none, .wall: return false
            case .floor, .entrance, .key: return true
            case .lock(let l): return ownedKeys.contains(l.lowercased())
            }
        }
    }

    func reachableKeys(from point: Point, visited: inout [Memo: [Point]]) -> [Key] {
        var result = [Key]()
        for key in keys {
            guard let s = key.value.key else { continue }
            if ownedKeys.contains(s) { continue }

            let path: [Point]
            let memo = Memo(point: point, key: s, ownedKeys: ownedKeys)
            if let memoed = visited[memo] {
                path = memoed
            } else {
                let pathfinder = AStarPathfinder(map: self)
                path = pathfinder.shortestPathFrom(point, to: key.key)
                visited[memo] = path
            }

            if !path.isEmpty {
                result.append(Key(letter: s, point: key.key, distance: path.count - 1))
            }
        }
        return result
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

        let availableKeys = Set(vault.keys.values.compactMap { $0.key })
        var result = Int.max
        vault.moveToNextKey(from: vault.entrance, to: "",
                            availableKeys: availableKeys,
                            ownedKeys: [],
                            distanceSoFar: 0,
                            result: &result)

        return result
    }

    func part2() -> Int {
        return 0
    }
}
