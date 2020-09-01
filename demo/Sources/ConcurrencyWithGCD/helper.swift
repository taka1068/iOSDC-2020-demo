//
//  helper.swift
//  
//
//  Created by takanori on 2020/08/31.
//

import Foundation

func createIntArray(count: Int, upperBound: Int?) -> [Int] {
    let upperBound = upperBound ?? Int.max
    
    var array = [Int]()
    
    for _ in 0..<count {
        let randomElement = (0..<upperBound).randomElement()!
        array.append(randomElement)
    }
    
    return array
}

// inspired by https://github.com/objcio/S01E90-concurrent-map/blob/master/Concurrent%20Map/main.swift#L54
func benchmark(array: [Int], title: String, sortFunction: ((inout [Int]) -> Void)) -> [Int] {
    var copy = array
    let startTime = DispatchTime.now()
    sortFunction(&copy)
    let endTime = DispatchTime.now()
    let diff = Double(endTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 1_000_000_000 as Double

    print("\(title): \(diff) seconds")
    return copy
}

extension UnsafeMutableBufferPointer where Self.Element == Int {
    func insertionSort(low: Int, high: Int) {
        for i in low...high {
            let key = self[i]
            var j = i - 1
            
            while (j >= 0 && self[j] > key) {
                self[j + 1] = self[j]
                j = j - 1
            }
            self[j + 1] = key
        }
    }
}
