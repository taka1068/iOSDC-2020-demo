//
//  concurrentmap.swift
//  
//
//  Created by takanori on 2020/09/01.
//

import Foundation

extension Array {
    func concurrentMap<T>(_ transform: (Element) -> T) -> [T] {
        var result = Array<T?>(repeating: nil, count: count)
        
        let queue = DispatchQueue(label: "serial")
        
        DispatchQueue.concurrentPerform(iterations: count) { index in
            let element = self[index]
            let transformed = transform(element)
            
            queue.sync {
                result[index] = transformed
            }
        }
        return result.map { $0! }
        
    }
    
    func concurrentMap2<T>(_ transform: (Element) -> T) -> [T] {
        // https://taka1068.hatenablog.jp/entry/2020/09/20/034600
        var result = ContiguousArray<T?>.init(repeating: nil, count: count)
        
        result.withUnsafeMutableBufferPointer { buffer in
            DispatchQueue.concurrentPerform(iterations: buffer.count) { index in
                buffer[index] = transform(self[index])
            }
        }
        return result.map { $0! }
    }
}

func concurrentMapBenchmark() {
    
    print(greetings.count)
    var charCount1: Int?
    var charCount2: Int?
    var charCount3: Int?
    
    benchmark(title: "charCountWithMap") {
        charCount1 = greetings.map { $0.count }.reduce(0, +)
    }
    
    benchmark(title: "charCountWithConcurrentMap") {
        charCount2 = greetings.concurrentMap { $0.count }.reduce(0, +)
    }
    
    benchmark(title: "charCountWithConcurrentMap2") {
        charCount3 = greetings.concurrentMap2 { $0.count }.reduce(0, +)
    }
    
    print(charCount1! == charCount2!, charCount1! == charCount3!)
    
    //
    
    let countIdeographicCharacters: (String) -> Int = { string in
        string.unicodeScalars.filter { $0.properties.isIdeographic }.count
    }

    var ideographicCount1: Int?
    var ideographicCount2: Int?
    var ideographicCount3: Int?
    
    benchmark(title: "ideographicCountWithMap") {
        ideographicCount1 = largeStringArray.map(countIdeographicCharacters).reduce(0, +)
    }
    
    benchmark(title: "ideographicCountWithConcurrentMap") {
        ideographicCount2 = largeStringArray.concurrentMap(countIdeographicCharacters).reduce(0, +)
    }
    
    benchmark(title: "ideographicCountWithConcurrentMap2") {
        ideographicCount3 = largeStringArray.concurrentMap2(countIdeographicCharacters).reduce(0, +)
    }

    print(ideographicCount1! == ideographicCount2!, ideographicCount1! == ideographicCount3!)
}
