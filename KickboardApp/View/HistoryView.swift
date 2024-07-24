//
//  HistoryView.swift
//  KickboardApp
//
//  Created by 강유정 on 7/23/24.
//

import UIKit
import SnapKit

class HistoryView: UIView {
    
    // 이미지뷰 생성
    let profileImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .white
        image.layer.cornerRadius = 60
        image.layer.borderWidth = 2.5 // 테두리 두께
        image.layer.borderColor = UIColor.lightGray.cgColor // 테두리 색상
        image.contentMode = .scaleAspectFit
        image.layer.masksToBounds = true // 이미지 뷰 밖으로 나간 이미지를 자르기
        return image
    }()
    
    // UILabel 생성
    private let imageButton: UIButton = {
        let button = UIButton()
        button.setTitle("이미지 선택", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private let nicknameLabel : UILabel = {
        let button = UILabel()
        button.text = "닉네임 님"
        button.font = .boldSystemFont(ofSize: 18)
        button.textAlignment = .center
        
        return button
    }()
    
    private let infoLabel : UILabel = {
        let button = UILabel()
        button.text = "기본정보"
        button.textColor = .black
        button.font = .boldSystemFont(ofSize: 14)
        button.textAlignment = .left
        
        return button
    }()
    
    private let nameLabel : UILabel = {
        let button = UILabel()
        button.text = "이름   강유정"
        button.textColor = .gray
        button.font = .systemFont(ofSize: 14)
        button.textAlignment = .left
        
        return button
    }()
    
    private let emailLabel : UILabel = {
        let button = UILabel()
        button.text = "이메일   gni711@naver.com"
        button.textColor = .gray
        button.font = .systemFont(ofSize: 14)
        button.textAlignment = .left
        
        return button
    }()
    
    private let dateLabel : UILabel = {
        let button = UILabel()
        button.text = "생년월일   0000.00.00"
        button.textColor = .gray
        button.font = .systemFont(ofSize: 14)
        button.textAlignment = .left
        
        return button
    }()
    
    private var userInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10 // 내부의 각각의 아이템의 사이의 간격을 설정
        stackView.alignment = .leading
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 20
        
        // Padding 설정
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        
        return stackView
    }()
    
    // 이니셜라이저 지정
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemGray6
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func buttonTapped() {
        // 랜덤 사진 4장 로직 구현 예정
    }
    
    // 오토 레이아웃
    func configureUI() {
        // 리스트 열어서 위에 모든 클래스들 넣기
        [
            profileImage,
            imageButton,
            nicknameLabel,
            userInfoStackView
        ].forEach { self.addSubview($0) }
        
        profileImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(110)
            $0.width.height.equalTo(120)
        }
        
        imageButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileImage.snp.bottom).offset(10)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imageButton.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        userInfoStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(130)
        }
        
        [infoLabel, nameLabel, emailLabel, dateLabel]
            .forEach {userInfoStackView.addArrangedSubview($0)}
        
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(userInfoStackView.snp.top).inset(15)
            $0.leading.equalTo(userInfoStackView.snp.leading).offset(20)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(10)
        }
        
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(10)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom)
            $0.bottom.equalTo(userInfoStackView.snp.bottom).offset(20)
        }
        
    }
}
