import Foundation

concurrentMapBenchmark()

let array = createIntArray(count: 1_0000_0000, upperBound: nil)

let swiftSort = benchmark(array: array, title: "swift sort") { array in
    array.sort()
}

let quicksort = benchmark(array: array, title: "quick sort") { array in
    array.withContiguousMutableStorageIfAvailable { buffer in
        quickSort(buffer, low: 0, high: buffer.count - 1)
    }
}


let parallel1 = benchmark(array: array, title: "parallel quick sort 1") { array in
    let queue = DispatchQueue(label: "quicksort1", attributes: .concurrent)
    let group = DispatchGroup()
    
    array.withContiguousMutableStorageIfAvailable { buffer in
        parallelQuickSort1(buffer, low: 0, high: buffer.count - 1, queue: queue, group: group)
        group.wait()
    }
}


let parallel2 = benchmark(array: array, title: "parallel quick sort 2") { array in
    let queue = DispatchQueue(label: "quicksort2", attributes: .concurrent)
    let group = DispatchGroup()
    
    let semaphore = DispatchSemaphore(value: 8) // ProcessInfo().activeProcessorCount / 2 など
    
    array.withContiguousMutableStorageIfAvailable { buffer in
        parallelQuickSort2(buffer, low: 0, high: buffer.count - 1, queue: queue, group: group, semaphore: semaphore)
        group.wait()
    }
}

let performFurtherBenchmarkTests = false

guard performFurtherBenchmarkTests else {
    exit(0)
}


let semCountUpperBound = ProcessInfo().activeProcessorCount * 2
var results = [[Int]]()

for sem in 1..<semCountUpperBound {
    let result = benchmark(array: array, title: "parallel quick sort 2 with semaphore \(sem)") { array in
        let queue = DispatchQueue(label: "quicksort2", attributes: .concurrent)
        let group = DispatchGroup()
        
        let semaphore = DispatchSemaphore(value: sem)
        
        array.withContiguousMutableStorageIfAvailable { buffer in
            parallelQuickSort2(buffer, low: 0, high: buffer.count - 1, queue: queue, group: group, semaphore: semaphore)
            group.wait()
        }
    }
    results.append(result)
}

print(results.allSatisfy {$0 == swiftSort})

benchmark(title: "false sharing1", f: {
    falseSharing1()
})

benchmark(title: "false sharing2", f: {
    falseSharing2()
})
