import Foundation

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

print(swiftSort == parallel2, swiftSort == parallel1, swiftSort == quicksort)
