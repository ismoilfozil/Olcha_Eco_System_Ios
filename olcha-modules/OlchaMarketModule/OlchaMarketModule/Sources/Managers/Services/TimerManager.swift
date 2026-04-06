//
//  TimerManager.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 29/08/22.
//

import UIKit
class TimerManager {
    
    var observer: ((String) -> Void)?
    
    var timer: Timer?
    
    init() {
        updateTime()
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(updateTime),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc func updateTime() {
        let date = Date()
        let calendar = Calendar.current
        
        let hour = 23-calendar.component(.hour, from: date)
        let minute = 59-calendar.component(.minute, from: date)
        let second = 60-calendar.component(.second, from: date)
        
        
        observer?(fillHours(time: hour) + ":" + fillHours(time: minute) + ":" + fillHours(time: second))
    }
    
    private func fillHours(time: Int) -> String {
        if time.string.count < 2 {
            return "0" + time.string
        } else {
            return time.string
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
}
