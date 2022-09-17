//
//  File.swift
//  
//
//  Created by Gereon Steffens on 14.08.22.
//

import Foundation

func gcd(_ m: Int, _ n: Int) -> Int {
    let r = m % n
    if r != 0 {
        return gcd(n, r)
    } else {
        return n
    }
}

func lcm(_ m: Int, _ n: Int) -> Int {
    return m / gcd(m, n) * n
}
