import Foundation

//MARK: - Timer
public extension CardFillView {
    func startTimer() {
        timer?.invalidate()
        timer = nil
        
        sendButton.isHidden = true
        timeLabel.isHidden = false
        timerSeconds = 60
        countdown()
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(countdown),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    func stopTimer() {
        sendButton.isHidden = false
        timeLabel.isHidden = true
        timer?.invalidate()
        timer = nil
    }
    
    @objc func countdown() {
        timerSeconds -= 1
        
        if timerSeconds == 0 {
            buttonResend()
        }
        
        let minutes = (timerSeconds % 3600) / 60
        let seconds = (timerSeconds % 3600) % 60
        
        timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
}
