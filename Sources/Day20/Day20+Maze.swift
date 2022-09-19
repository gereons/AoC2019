//
//  File.swift
//  
//
//  Created by Gereon Steffens on 19.09.22.
//

import AoCTools

extension Day20 {
    enum Tile {
        case floor
        case wall
        case portal(String)

        var isFloor: Bool {
            switch self {
            case .floor: return true
            default: return false
            }
        }

        var isPortal: Bool {
            switch self {
            case .portal: return true
            default: return false
            }
        }

        var letter: String? {
            switch self {
            case .portal(let letter): return letter
            default: return nil
            }
        }
    }

    struct Portal: Hashable {
        let name: String
        let point: Point
    }

    class Maze {
        let points: [Point: Tile]
        private(set) var start = Point.zero
        private(set) var end = Point.zero
        private var connections = [Point: Point]()

        init(_ str: String) {
            var points = [Point: Tile]()
            for (y, line) in str.components(separatedBy: "\n").enumerated() {
                for (x, ch) in line.enumerated() {
                    let point = Point(x, y)
                    switch ch {
                    case "#": points[point] = .wall
                    case ".": points[point] = .floor
                    case "A"..."Z": points[point] = .portal(String(ch))
                    case " ": break
                    default: fatalError()
                    }
                }
            }
            self.points = points
        }

        func connectPortals() {
            var portals = Set<Portal>()
            for (point, _) in points.filter({ $0.value.isPortal }) {
                let portal = findPortal(at: point)
                portals.insert(portal)
            }

            start = portals.first { $0.name == "AA" }!.point
            end = portals.first { $0.name == "ZZ" }!.point

            var connections = [Point: Point]()
            for portal in portals {
                let pair = portals.filter { $0.name == portal.name }.map { $0 }
                if pair.count != 2 { continue }
                connections[pair[0].point] = pair[1].point
                connections[pair[1].point] = pair[0].point
            }
            self.connections = connections
        }

        func findPortal(at point: Point) -> Portal {
            let other = point.neighbors().filter { points[$0]?.isPortal == true }
            assert(other.count == 1)
            let l1 = (points[point]?.letter)!
            let l2 = (points[other[0]]?.letter)!
            let name = [l1, l2].sorted(by: <).joined()

            var portalPoint = Point.zero
            let p1 = point.neighbors().filter { points[$0]?.isFloor == true }
            let p2 = other[0].neighbors().filter { points[$0]?.isFloor == true }
            switch (p1.count, p2.count) {
            case (1, 0): portalPoint = p1[0]
            case (0, 1): portalPoint = p2[0]
            default: fatalError()
            }

            return Portal(name: name, point: portalPoint)
        }
    }
}

extension Day20.Maze: Pathfinding {
    func neighbors(for point: Point) -> [Point] {
        var neighbors = point.neighbors().filter { points[$0]?.isFloor == true }
        if let connect = connections[point] {
            neighbors.append(connect)
        }
        return neighbors
    }

    func hScore(from: Point, to: Point) -> Int {
        if let connect = connections[from], connect == to {
            return 1
        }
        return from.distance(to: to)
    }
}
