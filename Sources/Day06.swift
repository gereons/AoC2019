//
// Advent of Code 2019
//
// https://adventofcode.com/2019/day/6
//

import AoCTools

struct Orbit {
    let planet: String
    let orbiter: String

    init(_ string: String) {
        let parts = string.components(separatedBy: ")")
        planet = parts[0]
        orbiter = parts[1]
    }
}

final class Day06: AdventOfCodeDay {
    let title = "Universal Orbit Map"
    
    let orbits: [Orbit]

    init(input: String) {
        orbits = input.components(separatedBy: "\n").map { Orbit($0) }
    }

    func part1() -> Int {
        var dict = [String: [String]]()

        for orbit in orbits {
            dict[orbit.planet, default:[]].append(orbit.orbiter)
        }

        let root = TreeNode("COM")
        buildOrbitTree(dict, root)

        var total = 0
        root.visitAll { node, depth in
            total += depth
        }
        return total
    }

    private func buildOrbitTree(_ orbits: [String: [String]], _ tree: TreeNode<String>) {
        if let orbiters = orbits[tree.value] {
            for orbiter in orbiters {
                let node = TreeNode(orbiter)
                tree.add(node)
                buildOrbitTree(orbits, node)
            }
        }
    }

    func part2() -> Int {
        var dict = [String: [String]]()

        for orbit in orbits {
            dict[orbit.planet, default:[]].append(orbit.orbiter)
        }

        let tree = Tree(root: TreeNode("COM"))
        buildOrbitTree(dict, tree.root)

        let start = tree.first { $0 == "YOU" }!.parent!
        let end = tree.first { $0 == "SAN" }!.parent!

        let lca = tree.lowestCommonAncestor(of: start, and: end)

        return tree.level(of: start)! + tree.level(of: end)! - 2 * tree.level(of: lca)!
    }
}
