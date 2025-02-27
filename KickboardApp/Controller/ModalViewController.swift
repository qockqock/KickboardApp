//
//  ModalViewController.swift
//  KickboardApp
//
//  Created by 머성이 on 7/23/24.
//

import UIKit
import SnapKit
import SwiftUI

// 결제 수단 선택 델리게이트 프로토콜 정의
protocol PayHalfModalViewDelegate: AnyObject {
    func paymentMethodSelected(_ method: String)
}

class PayHalfModalViewController: UIViewController, PayHalfModalViewDelegate {
    
    private let payHalfModalView = PayHalfModalView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        payHalfModalView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        payHalfModalView.delegate = nil
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor.white
        
        view.addSubview(payHalfModalView)
        
        payHalfModalView.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.centerY.equalTo(view)
            $0.leading.equalTo(view).offset(16)
            $0.trailing.equalTo(view).offset(-16)
        }
        
        // 모달 바깥을 탭하면 모달을 닫기 위한 제스처 추가
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissModal))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func dismissModal() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 결제 수단 선택 시 호출되는 메서드
    func paymentMethodSelected(_ method: String) {
        // 선택된 결제 수단 처리
        print("Selected payment method: \(method)")
    }
}

protocol PromotionHalfModalViewControllerDelegate: AnyObject {
    func didUseCoupon(amount: Int)
}

class PromotionHalfModalViewController: UIViewController {
    
    private let promotionHalfModalView = PromotionHalfModalView()
    weak var delegate: PromotionHalfModalViewControllerDelegate? // 델리게이트 추가
    weak var delegate2: ReturnViewControllerDelegate?
    private let timerModel = TimerModel()
    private let returnView = ReturnView()
    
    // ReturnView를 초기화하는 생성자 추가
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        delegate = ReturnViewController.timer
        promotionHalfModalView.getCouponsButton.addTarget(self, action: #selector(promotionButtonTapped), for: .touchUpInside)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(promotionHalfModalView)
        
        promotionHalfModalView.snp.makeConstraints {
            $0.center.equalTo(view)
            $0.leading.equalTo(view).offset(16)
            $0.trailing.equalTo(view).offset(-16)
            $0.height.equalTo(208) // 원하는 높이 값으로 설정합니다.
        }
        
        // 모달 바깥을 탭하면 모달을 닫기 위한 제스처 추가
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissModal))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // 쿠폰사용 버튼액션
    @objc
    private func promotionButtonTapped() {
        // 쿠폰사용 버튼액션
        // payButton의 활성화 상태 확인
        if ReturnViewController.timer.returnView.payButton.isEnabled == true {
            // payButton이 활성화된 경우, 프로모션 및 결제수단 창 활성화
            self.alertManager(title: "사용완료", message: "쿠폰이 사용되었습니다.", confirmTitles: "확인", confirmActions: { [weak self] _ in
                // 쿠폰 금액
                let promotionAmount = 1000
                self?.delegate?.didUseCoupon(amount: promotionAmount)
                self?.dismiss(animated: true, completion: nil)
            })
        } else {
            // payButton이 비활성화된 경우, 프로모션 및 결제수단 창 비활성화
            self.alertManager(title: "알림", message: "쿠폰 사용이 불가능합니다.", confirmTitles: "확인", confirmActions: { _ in
            })
        }
    }
    
    
    @objc private func dismissModal() {
        self.dismiss(animated: true, completion: nil)
    }
}
