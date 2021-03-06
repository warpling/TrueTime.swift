//
//  TimedOperation.swift
//  TrueTime
//
//  Created by Michael Sanders on 7/18/16.
//  Copyright © 2016 Instacart. All rights reserved.
//

import Foundation

protocol TimedOperation: class {
    var started: Bool { get }
    var timeout: NSTimeInterval { get }
    var timer: dispatch_source_t? { get set }
    var timerQueue: dispatch_queue_t { get }

    func debugLog(@autoclosure message: () -> String)
    func timeoutError(error: NSError)
}

extension TimedOperation {
    func startTimer() {
        cancelTimer()
        timer = dispatchTimer(after: timeout, queue: timerQueue) {
            guard self.started else { return }
            self.debugLog("Got timeout for \(self)")
            self.timeoutError(NSError(trueTimeError: .TimedOut))
        }
    }

    func cancelTimer() {
        timer?.cancel()
        timer = nil
    }
}
