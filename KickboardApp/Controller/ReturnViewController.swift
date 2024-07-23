//
//  ReturnViewController.swift
//  KickboardApp
//
//  Created by 김승희 on 7/22/24.
//

import UIKit
import SnapKit

class ReturnViewController: UIViewController {
    
    // ReturnView에 있는 내용 갖고오기
    private let returnView = ReturnView()
    
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
//        returnView.promotionDetailButton.addTarget(self, action: #selector(promotionHalfModal), for: .touchUpInside)
    }
    
    // MARK: - 하프모달 func - DS
    // 내일 이야기 한 번 해봐야함
    // 어떤? -> 하프모달이 16버전 이상부터 높이를 커스텀 할 수 있어서, 16아래 버전은 깨지게 되는데, 어떻게해야할지에 대해 토의해야할 듯
    @objc
    private func payHalfModal() {
        let payHalfModalViewController = PayHalfModalViewController()
        payHalfModalViewController.modalPresentationStyle = .pageSheet

        if #available(iOS 16.0, *) {
                if let sheet = payHalfModalViewController.sheetPresentationController {
                    sheet.detents = [.custom { _ in
                        return 300 // 원하는 높이로 변경합니다. 예: 300 포인트
                    }]
                    sheet.preferredCornerRadius = 24.0
                }
                } else {
                    if let sheet = payHalfModalViewController.sheetPresentationController {
                        sheet.detents = [.medium()]
                        sheet.preferredCornerRadius = 24.0
                    }
                    payHalfModalViewController.preferredContentSize = CGSize(width: view.frame.width, height: 300)
                }
                present(payHalfModalViewController, animated: true, completion: nil)
            }
    }
