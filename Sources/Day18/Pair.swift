//
//  File.swift
//  
//
//  Created by Gereon Steffens on 17.09.22.
//

import Foundation

struct Pair<T, U> {
    let first: T
    let second: U

    init(_ first: T, _ second: U) {
        self.first = first
        self.second = second
    }

    var tuple: (T,U) { (first, second) }
}

extension Pair: Hashable where T: Hashable, U: Hashable {}
extension Pair: Equatable where T: Equatable, U: Equatable {}

struct Triple<T, U, V> {
    let first: T
    let second: U
    let third: V

    init(_ first: T, _ second: U, _ third: V) {
        self.first = first
        self.second = second
        self.third = third
    }

    var tuple: (T,U,V) { (first, second, third) }
}

extension Triple: Hashable where T: Hashable, U: Hashable, V: Hashable {}
extension Triple: Equatable where T: Equatable, U: Equatable, V: Equatable {}
