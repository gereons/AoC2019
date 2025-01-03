//
// Advent of Code 2019
//
// https://adventofcode.com/2019/day/12
//

import AoCTools
import Foundation

private enum Component: CaseIterable {
    case x, y, z
}

private struct Moon: Hashable {
    var position: Point3
    var velocity = Point3.zero

    init(_ position: Point3) {
        self.position = position
    }

    func components(_ component: Component) -> [Int] {
        switch component {
        case .x: return [position.x, velocity.x]
        case .y: return [position.y, velocity.y]
        case .z: return [position.z, velocity.z]
        }
    }

    var energy: Int { position.distance() * velocity.distance() }
}

final class Day12: AdventOfCodeDay {
    let title = "The N-Body Problem"
    
    let coordinates: [Point3]

    init(input: String) {
        // <x=-8, y=-10, z=0>
        let regex = Regex(pattern: #"<x=(-?\d*), y=(-?\d*), z=(-?\d*)>"#)

        coordinates = input.components(separatedBy: "\n").map { line -> Point3 in
            let matches = regex.matches(in: line)
            return Point3(Int(matches[0])!, Int(matches[1])!, Int(matches[2])!)
        }
    }

    func part1() -> Int {
        return part1(steps: 1000)
    }

    func part1(steps: Int) -> Int {
        var moons = coordinates.map { Moon($0) }

        for _ in 0..<steps {
            simulateStep(&moons)
        }

        return moons.reduce(0) { $0 + $1.energy }
    }

    private func simulateStep(_ moons: inout [Moon]) {
        for i in 0..<moons.count {
            updateVelocity(index: i, in: &moons)
        }

        for i in 0..<moons.count {
            moons[i].position = moons[i].position + moons[i].velocity
        }
    }

    private func updateVelocity(index: Int, in moons: inout [Moon]) {
        for (i, moon) in moons.enumerated() {
            if i == index { continue }

            var vX = moons[index].velocity.x
            var vY = moons[index].velocity.y
            var vZ = moons[index].velocity.z
            if moon.position.x > moons[index].position.x { vX = moons[index].velocity.x + 1 }
            if moon.position.x < moons[index].position.x { vX = moons[index].velocity.x - 1 }
            if moon.position.y > moons[index].position.y { vY = moons[index].velocity.y + 1 }
            if moon.position.y < moons[index].position.y { vY = moons[index].velocity.y - 1 }
            if moon.position.z > moons[index].position.z { vZ = moons[index].velocity.z + 1 }
            if moon.position.z < moons[index].position.z { vZ = moons[index].velocity.z - 1 }
            moons[index].velocity = Point3(vX, vY, vZ)
        }
    }

    func part2() -> Int {
        let result = Component.allCases.map { findCycle($0) }
        return lcm(result[0], lcm(result[1], result[2]))
    }

    private func findCycle(_ component: Component) -> Int {
        var moons = coordinates.map { Moon($0) }
        var seen = Set<[Int]>()
        var step = 0
        while true {
            var comp = [Int]()
            for i in 0..<moons.count {
                comp.append(contentsOf: moons[i].components(component))
            }

            if seen.contains(comp) {
                return step
            }
            seen.insert(comp)
            step += 1
            simulateStep(&moons)
        }
    }
}
