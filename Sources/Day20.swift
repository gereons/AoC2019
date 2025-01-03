//
// Advent of Code 2019
//
// https://adventofcode.com/2019/day/20
//

import AoCTools

final class Day20: AdventOfCodeDay {
    let title = "Donut Maze"
    
    let input: String

    init(input: String) {
        self.input = input
    }

    func part1() -> Int {
        let maze = Maze(input)
        maze.connectPortals()
        let pathfinder = AStarPathfinder(map: maze)
        let path = pathfinder.shortestPath(from: maze.start, to: maze.end)
        return path.count
    }

    func part2() -> Int {
        let maze = Maze3D(input, levels: 100)
        maze.connectPortals()
        let pathfinder = AStarPathfinder(map: maze)
        let path = pathfinder.shortestPath(from: maze.start, to: maze.end)
        return path.count
    }
}
