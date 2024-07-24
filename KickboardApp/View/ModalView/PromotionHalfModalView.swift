//
//  PromotionHalfModalView.swift
//  KickboardApp
//
//  Created by 머성이 on 7/24/24.
//

import UIKit
import SnapKit

class PromotionHalfModalView: UIView {
    
    // MARK: -  쿠폰 뷰 내 요소들 선언 - DS
    private let discountLabel: UILabel = {
        let label = UILabel()
        label.text = "10% 할인"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = UIColor.orange
        return label
    }()
    
    private let tagsLabel: UILabel = {
        let label = UILabel()
        label.text = "첫이용할인"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.gray
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        let text = """
        처음 이용하는 당신을 위한 쿠폰!
        많이 많이 이용해주세요~
        최대 2,000원 할인
        """
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    public let getCouponsButton: UIButton = {
        let button = UIButton()
        button.setTitle("쿠폰 받기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemTeal
        button.layer.cornerRadius = 10
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        // 테두리 생성
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 10
        
        [discountLabel, tagsLabel, descriptionLabel, getCouponsButton].forEach {
            self.addSubview($0)
        }
        
        // SnapKit을 사용하여 제약 조건 설정
        discountLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        tagsLabel.snp.makeConstraints {
            $0.top.equalTo(discountLabel.snp.bottom).offset(10)
            $0.leading.equalTo(discountLabel)
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
            $0.height.equalTo(50)
        }
    }
}
