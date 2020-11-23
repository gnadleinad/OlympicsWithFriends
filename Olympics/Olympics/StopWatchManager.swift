//
//  StopWatchManager.swift
//  Olympics
//
//  Created by Daniel Dang on 10/18/20.
//

import Foundation

class StopWatchManager: ObservableObject {
    
    @Published var secondsElapsed = 0.0
    @Published var mode: stopWatchMode = .stopped
    
    var timer = Timer()
    
    func start() {
        mode = .running
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            self.secondsElapsed = self.secondsElapsed + 0.01
        }
    }
    
    func stop() {
        timer.invalidate()
        secondsElapsed = 0
        mode = .stopped
    }
    
    func pause() {
        timer.invalidate()
        mode = .paused
    }
    
    enum stopWatchMode {
        case running
        case stopped
        case paused
    }
    
}
