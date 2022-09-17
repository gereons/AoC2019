//
//  File.swift
//  
//
//  Created by Gereon Steffens on 17.09.22.
//

import Foundation

extension Set {
    static func + (lhs: Set, rhs: Set) -> Set {
        lhs.union(rhs)
    }

    static func + (lhs: Set, rhs: Set.Element) -> Set {
        lhs.union([rhs])
    }

    static func - (lhs: Set, rhs: Set) -> Set {
        lhs.subtracting(rhs)
    }

    static func - (lhs: Set, rhs: Set.Element) -> Set {
        lhs.subtracting([rhs])
    }
}
