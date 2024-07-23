//
//  ModalView.swift
//  KickboardApp
//
//  Created by 머성이 on 7/23/24.
//

import UIKit
import SnapKit

class PayHalfModalView: UIView {
    // MARK: - 결제수단 하프모달 Value 관련 - DS
    // 결제수단 배열
    private let paymentMethods = ["킥키킥 페이머니", "신용/체크카드", "카카오페이", "토스페이"]
    weak var delegate: PayHalfModalViewDelegate?
    
    // 현재 선택된 라디오 버튼을 저장
    private var selectedRadioButton: UIButton?
    
    // 내용들을 스택뷰로 묶어서 관리하기 편하게 함
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // UI 구성 메서드
    private func configureUI() {
        addSubview(stackView)
        
        // 스택뷰 레이아웃 설정
        stackView.snp.makeConstraints {
            $0.top.equalTo(self).offset(32)
            $0.leading.equalTo(self).offset(16)
            $0.trailing.equalTo(self).offset(-16)
            $0.bottom.lessThanOrEqualTo(self).offset(-32)
        }
        
        // 결제수단 배열을 순회하며 각 결제수단 뷰 생성
        for method in paymentMethods {
            let containerView = createPaymentMethodView(method: method)
            stackView.addArrangedSubview(containerView)
        }
    }
    
    // MARK: - 결제수단 뷰 생성 메서드 (라디오 버튼 커스텀가능) - DS
    private func createPaymentMethodView(method: String) -> UIView {
        let containerView = UIView()
        
        let radioButton = UIButton(type: .custom)
        // 라디오 버튼 이미지 설정 (이미지 커스텀은 요기서! 클릭전, 후)
        radioButton.setImage(UIImage(systemName: "circle"), for: .normal)
        radioButton.setImage(UIImage(systemName: "circle.inset.filled"), for: .selected)
        
        radioButton.addTarget(self, action: #selector(radioButtonTapped(_:)), for: .touchUpInside)
        
        containerView.addSubview(radioButton)
        
        let label = UILabel()
        label.text = method
        label.font = UIFont.systemFont(ofSize: 18)
        containerView.addSubview(label)
        
        // 라디오 버튼 레이아웃 설정
        radioButton.snp.makeConstraints {
            $0.leading.equalTo(containerView)
            $0.centerY.equalTo(containerView)
            $0.width.height.equalTo(24)
        }
        
        // 레이블 레이아웃 설정
        label.snp.makeConstraints {
            $0.leading.equalTo(radioButton.snp.trailing).offset(8)
            $0.trailing.equalTo(containerView)
            $0.centerY.equalTo(containerView)
        }
        
        // 컨테이너 뷰 높이 설정
        containerView.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        return containerView
    }

    // 라디오 버튼 탭 시 호출되는 메서드
    @objc private func radioButtonTapped(_ sender: UIButton) {
        // 이전에 선택된 라디오 버튼의 선택 해제
        selectedRadioButton?.isSelected = false
        // 현재 탭된 라디오 버튼 선택
        sender.isSelected = true
        selectedRadioButton = sender
        
        // 선택된 라디오 버튼에 해당하는 결제수단 찾기
        if let index = stackView.arrangedSubviews.firstIndex(where: { ($0.subviews.first as? UIButton) == sender }) {
            let selectedMethod = paymentMethods[index]
            // 델리게이트 메서드 호출
            delegate?.paymentMethodSelected(selectedMethod)
        }
    }
}
