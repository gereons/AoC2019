//
//  File.swift
//  
//
//  Created by Gereon Steffens on 03.09.22.
//

import Foundation

//
//  AStar.swift
//
//  Advent of Code Tools
//
//  based on
//  https://www.raywenderlich.com/1734-how-to-implement-a-pathfinding-with-swift
//  and
//  https://github.com/davecom/SwiftPriorityQueue/blob/master/SwiftPriorityQueue/astar.swift
//

import AoCTools

protocol Pathfinding {
    associatedtype Coordinate: Hashable
    associatedtype Cost: Hashable, Numeric, Comparable
    typealias Node = PathNode<Coordinate, Cost>

    func neighbors(for: Coordinate, node: Node) -> [Coordinate]
    func costToMove(from: Coordinate, to: Coordinate) -> Cost

    func hScore(from: Coordinate, to: Coordinate) -> Cost
}

extension Pathfinding where Coordinate == Point, Cost == Int {
    func costToMove(from: Point, to: Point) -> Int {
        1
    }

    func hScore(from: Point, to: Point) -> Int {
        from.distance(to: to)
    }
}

// MARK: - implementation

final class PathNode<Coordinate: Hashable, Cost: Numeric & Comparable>: Hashable, Comparable, CustomDebugStringConvertible {
    public let coordinate: Coordinate
    public let parent: PathNode?

    var fScore: Cost { gScore + hScore }
    let gScore: Cost
    let hScore: Cost

    init(coordinate: Coordinate, parent: PathNode? = nil, moveCost: Cost = 0, hScore: Cost = 0) {
        self.coordinate = coordinate
        self.parent = parent
        self.gScore = (parent?.gScore ?? 0) + moveCost
        self.hScore = hScore
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(coordinate)
    }

    static func ==(lhs: PathNode, rhs: PathNode) -> Bool {
        lhs.coordinate == rhs.coordinate
    }

    static func < (lhs: PathNode, rhs: PathNode) -> Bool {
        lhs.fScore < rhs.fScore
    }

    var debugDescription: String {
        "pos=\(coordinate) g=\(gScore) h=\(hScore) f=\(fScore)"
    }
}

final class AStarPathfinder<PF: Pathfinding> {
    typealias Coordinate = PF.Coordinate
    typealias Cost = PF.Cost

    private let map: PF

    public init(map: PF) {
        self.map = map
    }

    public func shortestPath(from start: Coordinate, to destination: Coordinate) -> [Coordinate] {
        var frontier = Heap<PathNode<Coordinate, Cost>>.minHeap()
        frontier.insert(PathNode(coordinate: start))

        var explored = [Coordinate: Cost]()
        explored[start] = 0

        while let currentNode = frontier.pop() {
            let currentCoordinate = currentNode.coordinate

            if currentCoordinate == destination {
                var result = [Coordinate]()
                var node: PathNode? = currentNode
                while let n = node {
                    result.append(n.coordinate)
                    node = n.parent
                }
                return Array(result.reversed().dropFirst())
            }

            for neighbor in map.neighbors(for: currentCoordinate, node: currentNode) {
                let moveCost = map.costToMove(from: currentCoordinate, to: neighbor)
                let newcost = currentNode.gScore + moveCost

                if (explored[neighbor] == nil) || (explored[neighbor]! > newcost) {
                    explored[neighbor] = newcost
                    let hScore = map.hScore(from: currentCoordinate, to: neighbor)
                    let node = PathNode(coordinate: neighbor, parent: currentNode, moveCost: moveCost, hScore: hScore)
                    frontier.insert(node)
                }
            }
        }

        return []
    }
}
