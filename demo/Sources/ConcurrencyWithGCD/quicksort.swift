//
//  quicksort1.swift
//  
//
//  Created by takanori on 2020/08/31.
//

import Foundation

func quickSort(_ buffer: UnsafeMutableBufferPointer<Int>, low: Int, high: Int) {
    guard high > low else { return }
    guard high - low > 15 else {
        buffer.insertionSort(low: low, high: high)
        return
    }
    
    let pivot = partition(arrayBuffer: buffer, low: low, high: high)
    
    quickSort(buffer, low: low, high: pivot - 1)
    quickSort(buffer, low: pivot + 1, high: high)
}


func parallelQuickSort1(
    _ buffer: UnsafeMutableBufferPointer<Int>, low: Int, high: Int,
    queue: DispatchQueue, group: DispatchGroup) {
    guard high > low else { return }
    guard high - low > 15 else {
        buffer.insertionSort(low: low, high: high)
        return
    }
    
    let pivot = partition(arrayBuffer: buffer, low: low, high: high)
    
    queue.async(group: group) {
        parallelQuickSort1(buffer, low: low, high: pivot - 1, queue: queue, group: group)
        parallelQuickSort1(buffer, low: pivot + 1, high: high, queue: queue, group: group)
    }
}

func parallelQuickSort2(
    _ buffer: UnsafeMutableBufferPointer<Int>, low: Int, high: Int,
    queue: DispatchQueue, group: DispatchGroup, semaphore: DispatchSemaphore) {
    guard high > low else { return }
    guard high - low > 15 else {
        buffer.insertionSort(low: low, high: high)
        return
    }
    
    let pivot = partition(arrayBuffer: buffer, low: low, high: high)
    
    let waitResult = semaphore.wait(timeout: .now())
    
    switch waitResult {
    case .success:
        queue.async(group: group) {
            parallelQuickSort2(buffer, low: low, high: pivot - 1, queue: queue, group: group, semaphore: semaphore)
            parallelQuickSort2(buffer, low: pivot + 1, high: high, queue: queue, group: group, semaphore: semaphore)
            semaphore.signal()
        }
    case .timedOut:
        parallelQuickSort2(buffer, low: low, high: pivot - 1, queue: queue, group: group, semaphore: semaphore)
        parallelQuickSort2(buffer, low: pivot + 1, high: high, queue: queue, group: group, semaphore: semaphore)
    }
    
}
