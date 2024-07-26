//
//  HistoryView.swift
//  KickboardApp
//
//  Created by 강유정 on 7/23/24.
//

import UIKit
import SnapKit

class HistoryView: UIView {
    
    let mypageLabel: UILabel = {
        let label = UILabel()
        label.text = "마이페이지"
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    let profileImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "DefaultProfileImage")
        image.backgroundColor = .white
        image.layer.cornerRadius = 60
        image.layer.borderWidth = 1.0 // 테두리 두께
        image.layer.borderColor = UIColor.lightGray.cgColor // 테두리 색상
        image.contentMode = .scaleAspectFit
        image.layer.masksToBounds = true // 이미지 뷰 밖으로 나간 이미지를 자르기
        return image
    }()
    
    let imageButton: UIButton = {
        let button = UIButton()
        button.setTitle("이미지 선택", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        return button
    }()
    
    let nicknameLabel : UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    private let infoLabel : UILabel = {
        let label = UILabel()
        label.text = "기본정보"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .left
        return label
    }()
    
    let idLabel : UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        return label
    }()
    
    let emailLabel : UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        return label
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
    
    private var detailInfoStackView1: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 20
        return stackView
    }()
    
    private var detailInfoStackView2: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 20
        return stackView
    }()
    
    private let detailinfoLabel : UILabel = {
        let label = UILabel()
        label.text = "부가정보"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .left
        return label
    }()
    
    private let phoneNumberLabel : UILabel = {
        let button = UILabel()
        button.text = "휴대폰"
        button.textColor = .gray
        button.font = .systemFont(ofSize: 14)
        button.textAlignment = .left
        return button
    }()
    
    var phoneChangeButton : UIButton = {
        let button = UIButton()
        button.setTitle("변경", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        return button
    }()
    
    private let birthDateLabel : UILabel = {
        let button = UILabel()
        button.text = "생년월일"
        button.textColor = .gray
        button.font = .systemFont(ofSize: 14)
        button.textAlignment = .left
        return button
    }()
    
    var dateChangeButton : UIButton = {
        let button = UIButton()
        button.setTitle("변경", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        return button
    }()
    
    private let detailUse : UILabel = {
        let label = UILabel()
        label.text = "이용 내역"
        label.font = .boldSystemFont(ofSize: 17)
        label.textAlignment = .left
        return label
    }()
    
    let loginOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        return button
    }()
    
    let useKickboardLabel: UILabel = {
        let label = UILabel()
        label.text = "\" 현재 킥보드를 이용하고 있지 않습니다. \""
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    let quitButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원탈퇴", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        return button
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
    
    // 오토 레이아웃
    func configureUI() {
        // 리스트 열어서 위에 모든 클래스들 넣기
        [mypageLabel, profileImage, imageButton, nicknameLabel, detailUse, userInfoStackView, useKickboardLabel, loginOutButton, quitButton]
            .forEach { self.addSubview($0) }
        
        mypageLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(80)
        }
        
        // 제약조건 수정 - sh
        profileImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(mypageLabel.snp.bottom).offset(60)
            $0.width.height.equalTo(120)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileImage.snp.bottom).offset(18)
        }
        
        imageButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nicknameLabel.snp.bottom)
            $0.width.equalTo(100)
        }
        
        userInfoStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imageButton.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(180)
        }
        
        detailUse.snp.makeConstraints {
            $0.top.equalTo(userInfoStackView.snp.bottom).offset(25)
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.centerX.equalToSuperview()
        }
        
        useKickboardLabel.snp.makeConstraints {
            $0.top.equalTo(detailUse.snp.bottom).offset(18)
            $0.centerX.equalToSuperview()
        }
        
        loginOutButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(30)
            $0.leading.equalToSuperview().offset(75)
            $0.height.equalTo(35)
            $0.width.equalTo(75)
        }
        
        
        // 회원탈퇴 버튼 추가하며 loginOutButton 제약조건 수정 - sh
        quitButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(30)
            $0.trailing.equalToSuperview().offset(-75)
            $0.height.equalTo(35)
            $0.width.equalTo(75)
        }
        
        [infoLabel, idLabel, emailLabel, detailinfoLabel, detailInfoStackView1, detailInfoStackView2]
            .forEach {userInfoStackView.addArrangedSubview($0)}
        
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(userInfoStackView.snp.top).inset(18)
            $0.leading.equalTo(userInfoStackView.snp.leading).offset(20)
        }
        
        idLabel.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(10)
        }
        
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(35)
        }
        
        detailinfoLabel.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(30)
        }
        
        detailInfoStackView1.snp.makeConstraints {
            $0.top.equalTo(detailinfoLabel.snp.bottom).offset(25)
        }
        
        detailInfoStackView2.snp.makeConstraints {
            $0.top.equalTo(detailinfoLabel.snp.bottom).offset(35)
        }
        
        [phoneNumberLabel, phoneChangeButton]
            .forEach {detailInfoStackView1.addArrangedSubview($0)}
        
        phoneChangeButton.snp.makeConstraints {
            $0.trailing.equalTo(userInfoStackView.snp.trailing).inset(20)
            $0.width.equalTo(40)
        }
        
        [birthDateLabel, dateChangeButton]
            .forEach {detailInfoStackView2.addArrangedSubview($0)}
        
        dateChangeButton.snp.makeConstraints {
            $0.trailing.equalTo(userInfoStackView.snp.trailing).inset(20)
            $0.width.equalTo(40)
        }
        
    }
}

