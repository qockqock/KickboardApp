//
//  ReturnView.swift
//  KickboardApp
//
//  Created by 머성이 on 7/22/24.
//

import UIKit
import SnapKit

class ReturnView: UIView {
    
    // MARK: - 폰트 기본 설정 클로저
    // Label 생성 클로저
    private let createLabel: (String, CGFloat) -> UILabel = { text, fontSize in
        let label = UILabel()
        label.text = text
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: fontSize)
        return label
    }
    
    // MARK: - 이용시간, 결제금액, 프로모션, 최종 금액 관련 레이블 선언
    private lazy var usageTimeLabel = createLabel("이용시간", 16)
    private lazy var paymentAmountLabel = createLabel("결제금액", 16)
    private lazy var promotionLabel = createLabel("프로모션", 16)
    private lazy var totalAmountLabel = createLabel("최종금액", 24)
    
    lazy var usageTimeValueLabel = createLabel("00:00:00", 16)
    lazy var paymentAmountValueLabel = createLabel("0원", 16)
    lazy var promotionValueLabel = createLabel("0원", 16)
    lazy var totalAmountValueLabel = createLabel("0원", 24)
    
    // MARK: - 결제수단, 프로모션, 결제하기관련 버튼 관련
    public lazy var paymentMethodDetailButton: UIButton = {
        let button = UIButton()
        button.setTitle("결제수단", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = .systemPurple
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    public lazy var promotionDetailButton: UIButton = {
        let button = UIButton()
        button.setTitle("프로모션", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor.systemGray4
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    public lazy var payButton: UIButton = {
        let button = UIButton()
        button.setTitle("결제하기", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.backgroundColor = .twPurple
        button.layer.cornerRadius = 15
        button.isEnabled = false // 처음에는 비활성화
        return button
    }()
    
    // MARK: - 상단 이미지
    private let topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "kickKeyKick")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        
        totalAmountValueLabel.text = paymentAmountValueLabel.text // 초기값 설정
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        setupTopImageView()
        setupTopContainerView()
        setupBottomContainerView()
        setupPayButton()
    }
    
    // MARK: - 상단 이미지 뷰 설정
    private func setupTopImageView() {
        self.addSubview(topImageView)
        
        topImageView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(20)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
//            $0.width.equalTo(496)
//            $0.height.equalTo(56)
        }
    }

    // MARK: - 상단 컨테이너 뷰 설정 (이용시간, 결제금액, 프로모션)
    private func setupTopContainerView() {
        let topContainerView = createContainerView()
        
        [usageTimeLabel, usageTimeValueLabel, paymentAmountLabel, paymentAmountValueLabel, promotionLabel, promotionValueLabel].forEach {
            topContainerView.addSubview($0)
        }
        
        self.addSubview(topContainerView)
        
        topContainerView.snp.makeConstraints {
            $0.top.equalTo(topImageView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(150)
        }
        
        setupTopContainerViewConstraints(container: topContainerView)
    }

    // MARK: - 상단 컨테이너 뷰 레이아웃
    private func setupTopContainerViewConstraints(container: UIView) {
        let containerHeight: CGFloat = 140
        let elementHeight = containerHeight / 3
        
        usageTimeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.height.equalTo(elementHeight - 10)
        }
        
        usageTimeValueLabel.snp.makeConstraints {
            $0.centerY.equalTo(usageTimeLabel)
            $0.trailing.equalToSuperview().offset(-10)
        }
        
        addSeparator(to: container, below: usageTimeLabel)
        
        paymentAmountLabel.snp.makeConstraints {
            $0.top.equalTo(usageTimeLabel.snp.bottom).offset(10)
            $0.leading.equalTo(usageTimeLabel)
            $0.height.equalTo(elementHeight - 10)
        }
        
        paymentAmountValueLabel.snp.makeConstraints {
            $0.centerY.equalTo(paymentAmountLabel)
            $0.trailing.equalTo(usageTimeValueLabel)
        }
        
        addSeparator(to: container, below: paymentAmountLabel)
        
        promotionLabel.snp.makeConstraints {
            $0.top.equalTo(paymentAmountLabel.snp.bottom).offset(10)
            $0.leading.equalTo(paymentAmountLabel)
            $0.height.equalTo(elementHeight - 10)
        }
        
        promotionValueLabel.snp.makeConstraints {
            $0.centerY.equalTo(promotionLabel)
            $0.trailing.equalTo(paymentAmountValueLabel)
        }
    }

    // MARK: - 하단 컨테이너 뷰 설정 (결제수단, 프로모션, 최종금액)
    private func setupBottomContainerView() {
        let bottomContainerView = createContainerView()
        bottomContainerView.layer.borderWidth = 0
        
        [paymentMethodDetailButton, promotionDetailButton, totalAmountLabel, totalAmountValueLabel].forEach {
            bottomContainerView.addSubview($0)
        }
        
        self.addSubview(bottomContainerView)
        
        bottomContainerView.snp.makeConstraints {
            $0.top.equalTo(self.subviews[1].snp.bottom).offset(20) // 상단 이미지뷰 추가 후 인덱스 변경
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        setupBottomContainerViewConstraints(container: bottomContainerView)
    }

    // MARK: - 하단 컨테이너 뷰 레이아웃
    private func setupBottomContainerViewConstraints(container: UIView) {
        paymentMethodDetailButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(80)
            $0.width.equalTo(356)
        }
        
        promotionDetailButton.snp.makeConstraints {
            $0.top.equalTo(paymentMethodDetailButton.snp.bottom).offset(15)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(80)
            $0.width.equalTo(356)
        }
        
        totalAmountLabel.snp.makeConstraints {
            $0.top.equalTo(promotionDetailButton.snp.bottom).offset(80)
            $0.leading.equalToSuperview().offset(10)
        }
        
        totalAmountValueLabel.snp.makeConstraints {
            $0.centerY.equalTo(totalAmountLabel)
            $0.trailing.equalTo(promotionDetailButton)
        }
        
        container.snp.makeConstraints {
            $0.bottom.equalTo(totalAmountLabel.snp.bottom).offset(10)
        }
    }

    // MARK: - 결제 버튼 설정
    private func setupPayButton() {
        self.addSubview(payButton)
        
        payButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(180)
            $0.height.equalTo(50)
        }
    }

    // MARK: - 컨테이너 뷰 생성 함수
    private func createContainerView() -> UIView {
        let containerView = UIView()
        containerView.layer.borderColor = UIColor.systemGray4.cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 10
        return containerView
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

    // MARK: - 분리선 생성 함수
    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = .systemGray4
        return separator
    }
    
    // MARK: - 값 초기화 관련
    func updateUsageTime(_ time: String) {
        usageTimeValueLabel.text = time
    }
    
    func updatePaymentAmount(_ amount: String) {
        paymentAmountValueLabel.text = amount
    }
    
    func updatePromotionAmount(_ amount: String) {
        promotionValueLabel.text = amount
    }
    
    func updateTotalAmount(_ amount: String) {
        totalAmountValueLabel.text = amount
    }
}
