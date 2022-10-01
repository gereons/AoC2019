//
//  String+ASCII.swift
//  
//
//  Created by Gereon Steffens on 01.10.22.
//

extension String {
    var ascii: [Int] {
        self.map { Int($0.asciiValue!) }
    }

    init(ints: [Int]) {
        let chars = ints.map { Character(UnicodeScalar($0)!) }
        self.init(chars)
    }
}
