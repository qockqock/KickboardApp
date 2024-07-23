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
    
    // MARK: - 폰트 기본 설정 클로저
    // 상단 뷰 Label 생성 클로저 (이용시간, 결제금액, 프로모션, 최종 금액)
    private let topLabel: (String) -> UILabel = { text in
        let label = UILabel()
        label.text = text
        label.textColor = .black
        return label
    }
    
    // 중앙 뷰 Label 생성 클로저 (결제수단, 프로모션 버튼)
    private let middleLabel: (String) -> UILabel = { text in
        let label = UILabel()
        label.text = text
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        
        return label
    }
    
    // MARK: - 이용시간, 결제금액, 프로모션 관련 레이블 선언 - DS
    // UI 요소들
    private lazy var usageTimeLabel = topLabel("이용시간:")
    private lazy var paymentAmountLabel = topLabel("결제금액:")
    private lazy var promotionLabel = topLabel("프로모션:")
    
    private lazy var paymentAmountValueLabel = topLabel("")
    private lazy var promotionValueLabel = topLabel("")
    private lazy var totalAmountValueLabel = topLabel("")
    
    // MARK: - 최종 금액, 결제수단, 프로모션 버튼 레이블
    private lazy var totalAmountLabel = middleLabel("최종금액")
    private lazy var usageTimeValueLabel = middleLabel("")
    private lazy var paymentMethodButton = middleLabel("결제수단")
    private lazy var promotionButton = middleLabel("프로모션")
    
    // Detail 버튼 생성
    private lazy var paymentMethodDetailButton: UIButton = {
        let button = UIButton()
        button.setTitle("Detail  >", for: .normal)
        button.setTitleColor(.systemGray4, for: .normal)
        return button
    }()
    
    private lazy var promotionDetailButton: UIButton = {
        let button = UIButton()
        button.setTitle("Detail  >", for: .normal)
        button.setTitleColor(.systemGray4, for: .normal)
        return button
    }()
    
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
        setupTopContainerView()
        setupBottomContainerView()
        setupPayButton()
    }

    // MARK: - 상단 컨테이너 뷰 설정 (이용시간, 결제금액, 프로모션)
    private func setupTopContainerView() {
        let topContainerView = createContainerView()
        
        [usageTimeLabel, usageTimeValueLabel, paymentAmountLabel, paymentAmountValueLabel, promotionLabel, promotionValueLabel].forEach {
            topContainerView.addSubview($0)
        }
        
        self.addSubview(topContainerView)
        
        topContainerView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(150)
        }
        
        setupTopContainerViewConstraints()
    }

    // MARK: - 상단 컨테이너 뷰 레이아웃
    private func setupTopContainerViewConstraints() {
        usageTimeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(10)
        }
        
        usageTimeValueLabel.snp.makeConstraints {
            $0.centerY.equalTo(usageTimeLabel)
            $0.trailing.equalToSuperview().offset(-10)
        }
        
        paymentAmountLabel.snp.makeConstraints {
            $0.top.equalTo(usageTimeLabel.snp.bottom).offset(10)
            $0.leading.equalTo(usageTimeLabel)
        }
        
        paymentAmountValueLabel.snp.makeConstraints {
            $0.centerY.equalTo(paymentAmountLabel)
            $0.trailing.equalTo(usageTimeValueLabel)
        }
        
        promotionLabel.snp.makeConstraints {
            $0.top.equalTo(paymentAmountLabel.snp.bottom).offset(10)
            $0.leading.equalTo(paymentAmountLabel)
        }
        
        promotionValueLabel.snp.makeConstraints {
            $0.centerY.equalTo(promotionLabel)
            $0.trailing.equalTo(paymentAmountValueLabel)
        }
    }

    // MARK: - 하단 컨테이너 뷰 설정 (결제수단, 프로모션, 최종금액)
    private func setupBottomContainerView() {
        let bottomContainerView = UIView()
        
        [paymentMethodButton, paymentMethodDetailButton, promotionButton, promotionDetailButton, totalAmountLabel, totalAmountValueLabel].forEach {
            bottomContainerView.addSubview($0)
        }
        
        self.addSubview(bottomContainerView)
        
        bottomContainerView.snp.makeConstraints {
            $0.top.equalTo(self.subviews[0].snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        setupBottomContainerViewConstraints(container: bottomContainerView)
    }

    // MARK: - 하단 컨테이너 뷰 레이아웃
    private func setupBottomContainerViewConstraints(container: UIView) {
        paymentMethodButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(10)
        }
        
        paymentMethodDetailButton.snp.makeConstraints {
            $0.top.equalTo(paymentMethodButton.snp.bottom).offset(5)
            $0.trailing.equalToSuperview().offset(-10)
        }
        
        addSeparator(to: container, below: paymentMethodDetailButton)
        
        promotionButton.snp.makeConstraints {
            $0.top.equalTo(paymentMethodDetailButton.snp.bottom).offset(15)
            $0.leading.equalTo(paymentMethodButton)
        }
        
        promotionDetailButton.snp.makeConstraints {
            $0.top.equalTo(promotionButton.snp.bottom).offset(5)
            $0.trailing.equalTo(paymentMethodDetailButton)
        }
        
        addSeparator(to: container, below: promotionDetailButton)
        
        totalAmountLabel.snp.makeConstraints {
            $0.top.equalTo(promotionDetailButton.snp.bottom).offset(15)
            $0.leading.equalTo(promotionButton)
        }
        
        totalAmountValueLabel.snp.makeConstraints {
            $0.centerY.equalTo(totalAmountLabel)
            $0.trailing.equalTo(promotionDetailButton)
        }
        
        container.snp.makeConstraints {
            $0.bottom.equalTo(totalAmountLabel.snp.bottom).offset(10)
        }
    }

    // MARK: - 분리선 추가
    private func addSeparator(to container: UIView, below view: UIView) {
        let separator = createSeparator()
        container.addSubview(separator)
        separator.snp.makeConstraints {
            $0.top.equalTo(view.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
    }

    // MARK: - 결제 버튼 설정
    private func setupPayButton() {
        self.addSubview(payButton)
        
        payButton.snp.makeConstraints {
            $0.top.equalTo(self.subviews[1].snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
    }

    // MARK: - 컨테이너 뷰 생성 함수 (혹시 몰라서 따로 뺌)
    private func createContainerView() -> UIView {
        let containerView = UIView()
        containerView.layer.borderColor = UIColor.gray.cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 10
        return containerView
    }

    // MARK: - 분리선 생성 함수 (얘도 마찬가지)
    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = .systemGray4
        return separator
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
