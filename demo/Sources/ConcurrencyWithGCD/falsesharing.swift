//
//  File.swift
//  
//
//  Created by takanori on 2020/09/06.
//

import Foundation

fileprivate let count = 1000_0000

var x = 3
var y = 3

func falseSharing1() {
    
    func sum() -> Int {
        var sum = 0
        for _ in 0..<count {
            sum += x
        }
        return sum;
    }

    func inc() {
        for _ in 0..<count {
            y += 1
        }
    }

    let group = DispatchGroup()

    DispatchQueue.global().async(group: group) {
        let _ = sum()
    }

    DispatchQueue.global().async(group: group) {
        inc()
    }

    group.wait()
}

class V {
    var x: Int = 3
    var y: Int = 3
}

let v = V()

func falseSharing2() {

    func sum() -> Int {
        var sum = 0
        for _ in 0..<count {
            sum += v.x
        }
        return sum
    }

    func inc() {
        for _ in 0..<count {
            v.y += 1
        }
    }

    let group = DispatchGroup()

    DispatchQueue.global().async(group: group) {
        let _ = sum()
    }

    DispatchQueue.global().async(group: group) {
        inc()
    }

    group.wait()
}

