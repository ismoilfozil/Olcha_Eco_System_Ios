//
//  TimerManager.swift
//  OlchaUtils
//
//  Created by Elbek Khasanov on 18/05/23.
//

import Foundation

public class SearchTimerManager {
    
    private var timer: Timer?
    private var completion: (() -> Void)?
    
    public init() {}
    
    public func startTimer(duration: TimeInterval = 0.5, restartOnNewValue: Bool = true, completion: (() -> Void)?) {
        self.completion = completion
        
        if restartOnNewValue {
            resetTimer()
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.timerFired()
        }
    }
    
    public func resetTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func timerFired() {
        completion?()
        completion = nil
    }
}
