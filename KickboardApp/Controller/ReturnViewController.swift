//
//  ReturnViewController.swift
//  KickboardApp
//
//  Created by 김승희 on 7/22/24.
//

import UIKit
import SnapKit

class ReturnViewController: UIViewController, TimerModelDelegate, PromotionHalfModalViewControllerDelegate {
    
    static let timer = ReturnViewController()
    
    private let returnView = ReturnView()
    private let timerModel = TimerModel()
    
    private init() {
        super.init(nibName: nil, bundle: nil)
        timerModel.delegate = self // 델리게이트 설정
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = returnView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // 결제수단, 프로모션 addTarget
        returnView.paymentMethodDetailButton.addTarget(self, action: #selector(payHalfModal), for: .touchUpInside)
        returnView.promotionDetailButton.addTarget(self, action: #selector(promotionHalfModal), for: .touchUpInside)
        returnView.payButton.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        
        // 타이머 관련 추가 - DS ( 앱 상태 변화 감지 )
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    // 타이머 시작 코드
    func startTimer() {
        timerModel.startTimer { [weak self] in
            self?.timerDidUpdate(time: self?.timerModel.formatTime() ?? "00:00:00", fare: "\(self?.timerModel.formatNumber(self?.timerModel.calculateFare() ?? 0) ?? "0")원")
        }
        returnView.payButton.isEnabled = false // 타이머 시작 시 결제 버튼 비활성화
    }
    
    // 타이머 멈추기
    func stopTimer() {
        timerModel.stopTimer()
        returnView.payButton.isEnabled = true // 타이머 멈춘 후 결제 버튼 활성화
    }
    
    // TimerModelDelegate 메서드
    func timerDidUpdate(time: String, fare: String) {
        returnView.updateUsageTime(time)
        returnView.updatePaymentAmount(fare)
        updateTotalAmount()
    }
    
    // PromotionHalfModalViewControllerDelegate 메서드
    func didUseCoupon(amount: Int) {
        returnView.updatePromotionAmount("-\(timerModel.formatNumber(amount))원")
        updateTotalAmount()
    }
    
    // 총금액 업데이트
    private func updateTotalAmount() {
        guard let paymentText = returnView.paymentAmountValueLabel.text,
              let paymentAmount = Int(paymentText.replacingOccurrences(of: "원", with: "").replacingOccurrences(of: ",", with: "")),
              let promotionText = returnView.promotionValueLabel.text,
              let promotionAmount = Int(promotionText.replacingOccurrences(of: "원", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: ",", with: "")) else {
            return
        }
        
        let finalAmount = paymentAmount - promotionAmount
        returnView.updateTotalAmount("\(timerModel.formatNumber(finalAmount))원")
    }
    
    // 앱이 백그라운드로 전환될 때 호출
    @objc func appDidEnterBackground() {
        timerModel.enterBackground()
    }
    
    // 앱이 포그라운드로 돌아올 때 호출
    @objc func appWillEnterForeground() {
        timerModel.enterForeground { [weak self] in
            self?.timerDidUpdate(time: self?.timerModel.formatTime() ?? "00:00:00", fare: "\(self?.timerModel.formatNumber(self?.timerModel.calculateFare() ?? 0) ?? "0")원")
        }
    }
    
    // 결제 버튼 클릭시 이벤트 - DS
    @objc
    private func payButtonTapped() {
        let alert = UIAlertController(title: "결제완료", message: "결제가 완료되었습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.resetValues()
            self?.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func resetValues() {
        // 모든 값 초기화
        timerModel.stopTimer()
        returnView.updateUsageTime("00:00:00")
        returnView.updatePaymentAmount("1,500원")
        returnView.updatePromotionAmount("-0원")
        returnView.updateTotalAmount("1,500원")
        returnView.payButton.isEnabled = false
    }
    
    // 하프모달 관련 코드
    @objc
    private func payHalfModal() {
        let payHalfModalViewController = PayHalfModalViewController()
        payHalfModalViewController.modalPresentationStyle = .pageSheet
        
        if let sheet = payHalfModalViewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 24.0
        }
        payHalfModalViewController.preferredContentSize = CGSize(width: view.frame.width, height: 300)
        
        present(payHalfModalViewController, animated: true, completion: nil)
    }
    
    @objc
    private func promotionHalfModal() {
        let promotionHalfModalViewController = PromotionHalfModalViewController()
        promotionHalfModalViewController.delegate = self // 델리게이트 설정
        promotionHalfModalViewController.modalPresentationStyle = .pageSheet
        
        if let sheet = promotionHalfModalViewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 24.0
        }
        promotionHalfModalViewController.preferredContentSize = CGSize(width: view.frame.width, height: 300)
        
        present(promotionHalfModalViewController, animated: true, completion: nil)
    }
}
