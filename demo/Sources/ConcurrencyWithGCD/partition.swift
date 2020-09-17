//
//  File.swift
//  
//
//  Created by takanori on 2020/08/31.
//

import Foundation

func partition(arrayBuffer buffer: UnsafeMutableBufferPointer<Int>, low: Int, high: Int) -> Int {
    let pivot = buffer[high]
    var pIndex = low
    
    for i in low..<high {
        if buffer[i] <= pivot {
            buffer.swapAt(i, pIndex)
            pIndex += 1
        }
    }
    
    buffer.swapAt(pIndex, high)
    return pIndex
}
