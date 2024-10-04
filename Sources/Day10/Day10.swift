//
// Advent of Code 2019
//
// https://adventofcode.com/2019/day/10
//

import AoCTools
import Foundation

final class Day10: AOCDay {
    let grid: Set<Point>
    let maxX: Int
    let maxY: Int

    init(input: String) {
        let lines = input.components(separatedBy: "\n")
        var grid = Set<Point>()
        for (y, line) in lines.enumerated() {
            for (x, ch) in line.enumerated() {
                if ch == "#" {
                    grid.insert(Point(x,y))
                }
            }
        }

        self.grid = grid
        self.maxX = lines[0].count - 1
        self.maxY = lines.count - 1
    }

    func part1() -> Int {
        let (visible, _) = maxVisible()
        return visible
    }

    private func maxVisible() -> (Int, Point) {
        var maxVisible = 0
        var maxPoint = Point.zero

        for point in grid {
            let visible = visible(from: point, in: grid)
            if visible > maxVisible {
                maxVisible = visible
                maxPoint = point
            }
        }
        return (maxVisible, maxPoint)
    }

    private func visible(from origin: Point, in grid: Set<Point>) -> Int {
        var visible = 0
        for point in grid {
            if point == origin { continue }

            let vector: Point
            let delta = Point(point.x - origin.x, point.y - origin.y)
            if delta.x == 0 {
                vector = Point(0, sign(delta.y))
            } else if delta.y == 0 {
                vector = Point(sign(delta.x), 0)
            } else {
                let gcd = abs(gcd(delta.x, delta.y))
                vector = Point(delta.x / gcd, delta.y / gcd)
            }

            var step = origin + vector
            var blocked = false
            while step != point {
                if grid.contains(step) {
                    blocked = true
                    break
                }
                step = step + vector
            }
            if !blocked {
                visible += 1
            }
        }

        return visible
    }

    private func sign(_ x: Int) -> Int {
        if x < 0 { return -1 }
        if x > 0 { return 1 }
        return 0
    }

    func part2() -> Int {
        let (_, origin) = maxVisible()

        var angles = findAngles(around: origin)

        var kills = 0
        for _ in 0 ... 100 {
            for (angle, points) in angles.sorted(by: { $0.key < $1.key }) {
                if let hit = points.first {
                    kills += 1
                    if kills == 200 {
                        return hit.x * 100 + hit.y
                    }
                    angles[angle] = Array(points.dropFirst())
                }
            }
        }

        return .zero
    }

    private func findAngles(around origin: Point) -> [Double: [Point]] {
        var byAngle = [Double: [Point]]()
        for point in grid {
            if point == origin { continue }

            let angle = atan2(Double(origin.x - point.x), Double(origin.y - point.y)).toDegrees
            var points = byAngle[angle, default: []]
            points.append(point)
            points.sort { p1, p2 in
                p1.distance(to: origin) < p2.distance(to: origin)
            }

            byAngle[angle] = points
        }

        return byAngle
    }
}

extension Point {
    func moved(_ direction: Direction) -> Point {
        self + direction.offset
    }
}

extension Double {
    var toDegrees: Double {
        let deg = self * 180 / .pi
        if deg == 0 { return 0 }
        if deg < 0 { return -deg }
        return 360 - deg
    }
}
