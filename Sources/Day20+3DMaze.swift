//
//  Day20+3DMaze.swift
//  
//
//  Created by Gereon Steffens on 19.09.22.
//

import Foundation

import AoCTools

extension Day20 {

    struct Portal3: Hashable {
        let name: String
        let point: Point3
    }

    final class Maze3D {
        private var points = [[Point: Tile]]()
        private(set) var start = Point3.zero
        private(set) var end = Point3.zero
        private var connections = [Point3: Point3]()
        private let levels: Int

        init(_ str: String, levels: Int) {
            self.levels = levels

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

            self.points = [points]
        }

        func connectPortals() {
            var portals = Set<Portal>()
            for (point, _) in points[0].filter({ $0.value.isPortal }) {
                let portal = findPortal(at: point)
                portals.insert(portal)
            }

            let aa = portals.first { $0.name == "AA" }!
            let zz = portals.first { $0.name == "ZZ" }!
            start = Point3(aa.point, 0)
            end = Point3(zz.point, 0)
            portals.remove(aa)
            portals.remove(zz)

            let minX = 2 // portals.map { $0.point.x }.min(by: <)!
            let maxX = portals.map { $0.point.x }.max(by: <)!
            let minY = 2 // portals.map { $0.point.y }.min(by: <)!
            let maxY = portals.map { $0.point.y }.max(by: <)!
            let isInner = { (point: Point) in
                point.x != minX && point.x != maxX && point.y != minY && point.y != maxY
            }

            var points = self.points[0]
            points[Point(end.x, end.y)] = .wall
            self.points.append(contentsOf: Array(repeating: points, count: levels - 1))

            let outerWalls = portals.filter { !isInner($0.point) }
            outerWalls.forEach {
                self.points[0][$0.point] = .wall
            }

            var connections = [Point3: Point3]()
            for level in 0..<levels {
                for portal in portals {
                    let pair = portals.filter { $0.name == portal.name }.map { $0 }
                    if pair.count != 2 {
                        continue
                    }
                    var z0 = level
                    var z1 = level
                    switch (isInner(pair[0].point), isInner(pair[1].point)) {
                    case (true, true):
                        print("a")
                    case (true, false):
                        z1 += 1
                    case (false, true):
                        z0 += 1
                    case (false, false):
                        z1 -= 1
                    }
                    connections[Point3(pair[0].point, z0)] = Point3(pair[1].point, z1)
                    connections[Point3(pair[1].point, z1)] = Point3(pair[0].point, z0)
                }
            }
            self.connections = connections
        }

        func findPortal(at point: Point) -> Portal {
            let other = point.neighbors().filter { points[0][$0]?.isPortal == true }
            assert(other.count == 1)
            let l1 = (points[0][point]?.letter)!
            let l2 = (points[0][other[0]]?.letter)!
            let name = [l1, l2].sorted(by: <).joined()

            var portalPoint = Point.zero
            let p1 = point.neighbors().filter { points[0][$0]?.isFloor == true }
            let p2 = other[0].neighbors().filter { points[0][$0]?.isFloor == true }
            switch (p1.count, p2.count) {
            case (1, 0): portalPoint = p1[0]
            case (0, 1): portalPoint = p2[0]
            default: fatalError()
            }

            return Portal(name: name, point: portalPoint)
        }
    }
}

extension Point3 {
    init(_ point: Point, _ z: Int) {
        self.init(point.x, point.y, z)
    }
}

extension Day20.Maze3D: Pathfinding {
    func neighbors(of point: Point3) -> [Point3] {
        let level = point.z
        if level >= self.levels {
            return []
        }
        var neighbors = point.neighbors()
            .filter { $0.z == level }
            .filter { points[level][Point($0.x, $0.y)]?.isFloor == true }
        if let connect = connections[point] {
            neighbors.append(connect)
        }
        return neighbors
    }

    func costToMove(from: Point3, to: Point3) -> Int {
        1
    }

    func distance(from: Point3, to: Point3) -> Int {
        if let connect = connections[from], connect == to {
            return 1
        }
        return from.distance(to: to)
    }
}
