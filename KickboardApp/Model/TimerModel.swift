//
//  TimerModel.swift
//  KickboardApp
//
//  Created by 머성이 on 7/24/24.
//

import Foundation

// MARK: - 타이머 관련 모델 - DS
class TimerModel {
    private(set) var counter: Int = 0
    private var timer: Timer?
    private var backgroundDate: Date?
    
    // 기본요금 설정
    private let baseFare = 1500
    private let farePerMinute = 100
    
    //타이머 시작
    func startTimer(update: @escaping () -> Void) {
        counter = 0
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.counter += 1
            update()
        }
    }
    
    // 타이머 중지
    func stopTimer() {
        timer?.invalidate()
    }

    // 앱이 백그라운드로 전환될 때 호출
    func enterBackground() {
        backgroundDate = Date()
    }

    // 앱이 포그라운드로 돌아올 때 호출
    func enterForeground(update: @escaping () -> Void) {
        if let backgroundDate = backgroundDate {
            let elapsed = Int(Date().timeIntervalSince(backgroundDate))
            counter += elapsed
            update()
        }
    }

    // 시:분:초 형식으로 시간을 포맷
    func formatTime() -> String {
        let hours = counter / 3600
        let minutes = (counter % 3600) / 60
        let seconds = counter % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    // 요금 계산
    func calculateFare() -> Int {
        let minutes = counter / 60
        return baseFare + minutes * farePerMinute
    }
    
    // 숫자를 세 자리마다 쉼표를 추가하여 포맷
    func formatNumber(_ fare: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: fare)) ?? "\(fare)"
    }
    
    
}
