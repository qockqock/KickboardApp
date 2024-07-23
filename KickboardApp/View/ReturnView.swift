//
//  ReturnView.swift
//  KickboardApp
//
//  Created by 머성이 on 7/22/24.
//

import UIKit
import SnapKit
import SwiftUI

class ReturnView: UIView {
    
    // Label 생성 클로저
    private let createLabel: (String) -> UILabel = { text in
        let label = UILabel()
        label.text = text
        label.textColor = .black
        return label
    }
    
    // MARK: - 이용시간, 결제금액, 프로모션, 총 금액 관련 레이블 선언 - DS
    // UI 요소들
    private lazy var usageTimeLabel = createLabel("이용시간:")
    private lazy var paymentAmountLabel = createLabel("결제금액:")
    private lazy var promotionLabel = createLabel("프로모션:")
    private lazy var totalAmountLabel = createLabel("최종금액:")
    
    private lazy var usageTimeValueLabel = createLabel("")
    private lazy var paymentAmountValueLabel = createLabel("")
    private lazy var promotionValueLabel = createLabel("")
    private lazy var totalAmountValueLabel = createLabel("")
    
    // MARK: - 결제하기 버튼 관련 - DS
    private lazy var payButton: UIButton = {
        let button = UIButton()
        button.setTitle("결제하기", for: .normal)
        button.backgroundColor = .purple
        button.layer.cornerRadius = 10
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        // MARK: - 이용시간, 결제금액, 프로모션 묶기
        let containerView = UIView()
        containerView.layer.borderColor = UIColor.gray.cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 10
        
        // 이용시간, 결제금액, 프로모션 addSubview 하기
        [usageTimeLabel, usageTimeValueLabel, paymentAmountLabel, paymentAmountValueLabel, promotionLabel, promotionValueLabel].forEach {
            containerView.addSubview($0)
        }
        
        // 상단 뷰, 총 금액 관련, 결제 버튼 addSubview 하기
        [containerView, totalAmountLabel, totalAmountValueLabel, payButton].forEach {
            self.addSubview($0)
        }
        
        // MARK: - 상단 뷰 레이아웃
        containerView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(100)
        }
        
        // MARK: - 총 금액, 하단 결제 버튼 레이아웃
        totalAmountLabel.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.bottom).offset(20)
            $0.leading.equalTo(containerView)
        }
        
        totalAmountValueLabel.snp.makeConstraints {
            $0.top.equalTo(totalAmountLabel)
            $0.trailing.equalTo(containerView)
        }
        
        payButton.snp.makeConstraints {
            $0.top.equalTo(totalAmountLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(containerView)
            $0.height.equalTo(50)
        }
        
        // MARK: - 상단 뷰 Value 레이아웃
        usageTimeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(10)
        }
        
        usageTimeValueLabel.snp.makeConstraints {
            $0.top.equalTo(usageTimeLabel)
            $0.trailing.equalToSuperview().offset(-10)
        }
        
        paymentAmountLabel.snp.makeConstraints {
            $0.top.equalTo(usageTimeLabel.snp.bottom).offset(10)
            $0.leading.equalTo(usageTimeLabel)
        }
        
        paymentAmountValueLabel.snp.makeConstraints {
            $0.top.equalTo(paymentAmountLabel)
            $0.trailing.equalTo(usageTimeValueLabel)
        }
        
        promotionLabel.snp.makeConstraints {
            $0.top.equalTo(paymentAmountLabel.snp.bottom).offset(10)
            $0.leading.equalTo(paymentAmountLabel)
        }
        
        promotionValueLabel.snp.makeConstraints {
            $0.top.equalTo(promotionLabel)
            $0.trailing.equalTo(paymentAmountValueLabel)
        }
    }
}

//struct PreView: PreviewProvider {
//  static var previews: some View {
//    ReturnViewController().toPreview()
//  }
//}
//#if DEBUG
//extension UIViewController {
//  private struct Preview: UIViewControllerRepresentable {
//      let viewController: UIViewController
//      func makeUIViewController(context: Context) -> UIViewController {
//        return viewController
//      }
//      func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//      }
//    }
//    func toPreview() -> some View {
//      Preview(viewController: self)
//    }
//}
//#endif
