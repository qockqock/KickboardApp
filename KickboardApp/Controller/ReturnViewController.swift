//
//  ReturnViewController.swift
//  KickboardApp
//
//  Created by 김승희 on 7/22/24.
//

import UIKit
import SnapKit

class ReturnViewController: UIViewController {
    
    private let returnView = ReturnView()
    private let timerModel = TimerModel()
    
    // 정보 받아와서 값 넣을꺼
    //    private let returnInfo = ReturnInfo(usageTime: "14:31", paymentAmount: 5900, promotionDiscount: 1000, totalAmount: 4900)
    
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
    
    // MARK: - 타이머 시작
    
    // 대여하기 버튼 클릭 후 타이머 진행관련 코드 작성예정
    //    timerModel.startTimer { [weak self] in
    //        self?.updateLabels()
    //    }
    
    // 레이블 업데이트
    private func updateLabels() {
        returnView.usageTimeValueLabel.text = timerModel.formatTime()
        let fare = timerModel.calculateFare()
        returnView.paymentAmountValueLabel.text = "\(timerModel.formatNumber(fare))원"
        returnView.totalAmountValueLabel.text = "\(timerModel.formatNumber(fare))"
    }
    
    // 앱이 백그라운드로 전환될 때 호출
    @objc func appDidEnterBackground() {
        timerModel.enterBackground()
    }
    
    // 앱이 포그라운드로 돌아올 때 호출
    @objc func appWillEnterForeground() {
        timerModel.enterForeground { [weak self] in
            self?.updateLabels()
        }
    }
    
    // MARK: - 결제버튼 클릭시 이벤트 - DS
    @objc
    private func payButtonTapped() {
        let alert = UIAlertController(title: "결제완료", message: "결제가 완료되었습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        
        // 값 초기화 해줄 코드 작성하면 됨
         
//        // 임시 타이머 코드
//        timerModel.startTimer { [weak self] in
//            self?.updateLabels()
//        }
    }
    
    // 타이머 시작 코드
    func startTimer() {
        timerModel.startTimer { [weak self] in
            self?.updateLabels()
        }
    }
    
    // MARK: - 하프모달 func - DS
    // 내일 이야기 한 번 해봐야함
    // 어떤? -> 하프모달이 16버전 이상부터 높이를 커스텀 할 수 있어서, 16아래 버전은 깨지게 되는데, 어떻게해야할지에 대해 토의해야할 듯
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
        let promotionHalfModalViewController = PromotionHalfModalViewController(returnView: returnView)
        promotionHalfModalViewController.modalPresentationStyle = .pageSheet
        
        if let sheet = promotionHalfModalViewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 24.0
        }
        promotionHalfModalViewController.preferredContentSize = CGSize(width: view.frame.width, height: 300)
        
        present(promotionHalfModalViewController, animated: true, completion: nil)
    }
}
