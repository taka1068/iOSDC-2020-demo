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
}

func concurrentMapBenchmark() {
    
    print(greetings.count)
    var charCount1: Int?
    var charCount2: Int?
    
    benchmark(title: "charCountWithMap") {
        charCount1 = greetings.map { $0.count }.reduce(0, +)
    }
    
    benchmark(title: "charCountWithConcurrentMap") {
        charCount2 = greetings.concurrentMap { $0.count }.reduce(0, +)
    }
    
    print(charCount1! == charCount2!)
    
    //
    
    let countIdeographicCharacters: (String) -> Int = { string in
        string.unicodeScalars.filter { $0.properties.isIdeographic }.count
    }

    var ideographicCount1: Int?
    var ideographicCount2: Int?
    
    benchmark(title: "ideographicCountWithMap") {
        ideographicCount1 = largeStringArray.map(countIdeographicCharacters).reduce(0, +)
    }
    
    benchmark(title: "ideographicCountWithConcurrentMap") {
        ideographicCount2 = largeStringArray.concurrentMap(countIdeographicCharacters).reduce(0, +)
    }

    print(ideographicCount1! == ideographicCount2!)
    
    print("kokoro count", largeStringArray.map { $0.count }.reduce(0, +))
}
