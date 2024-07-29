//
//  PromotionHalfModalView.swift
//  KickboardApp
//
//  Created by 머성이 on 7/24/24.
//

import UIKit
import SnapKit
import SwiftUI

class PromotionHalfModalView: UIView {
    
    // MARK: -  쿠폰 뷰 내 요소들 선언 (사용 전) - DS
    private let couponBoxLabel: UILabel = {
        let label = UILabel()
        label.text = "쿠폰함"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.black
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 10
        return view
    }()
    
    private let discountLabel: UILabel = {
        let label = UILabel()
        label.text = "1,000원 할인"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = UIColor.orange
        return label
    }()
    
    private let tagsLabel: UILabel = {
        let label = UILabel()
        label.text = " 첫이용할인"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.systemPink
        
        label.setRoundedCorners(radius: 8.0, backgroundColor: UIColor.systemPink.withAlphaComponent(0.1), borderColor: UIColor.purple, borderWidth: 0)
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        let text = "처음 이용하시면 할인 받아요"
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.systemGray
        label.numberOfLines = 0
        return label
    }()
    
    public let getCouponsButton: UIButton = {
        let button = UIButton()
        button.setTitle("쿠폰사용", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemTeal
        button.layer.cornerRadius = 10
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(couponBoxLabel)
        addSubview(containerView)
        
        // SnapKit을 사용하여 couponBoxLabel 제약 조건 설정
        couponBoxLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(-40)
            $0.leading.equalToSuperview().offset(16)
        }
        
        // SnapKit을 사용하여 containerView 제약 조건 설정
        containerView.snp.makeConstraints {
            $0.top.equalTo(couponBoxLabel.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview().inset(10)
        }
        
        [discountLabel, tagsLabel, descriptionLabel, getCouponsButton].forEach {
            containerView.addSubview($0)
        }
        
        // SnapKit을 사용하여 제약 조건 설정
        discountLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        tagsLabel.snp.makeConstraints {
            $0.top.equalTo(discountLabel.snp.bottom).offset(10)
            $0.leading.equalTo(discountLabel)
            $0.width.equalTo(68)
            $0.height.equalTo(24)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(tagsLabel.snp.bottom).offset(10)
            $0.leading.equalTo(discountLabel)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        getCouponsButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(40)
        }
    }
}

// MARK: - 쿠폰 테두리 관련 - DS
extension UILabel {
    func setRoundedCorners(radius: CGFloat, backgroundColor: UIColor, borderColor: UIColor, borderWidth: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.backgroundColor = backgroundColor
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
    }
}
