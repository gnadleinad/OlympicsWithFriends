//
//  CounterManager.swift
//  Olympics
//
//  Created by Daniel Dang on 10/25/20.
//


import Foundation

class CounterManager: ObservableObject {
    
    @Published var currentCount = 0
    
    func increment() {
        currentCount += 1
    }
    
    func decrement() {
        currentCount -= 1
    }
    
    func reset() {
        currentCount = 0
    }
    
}

