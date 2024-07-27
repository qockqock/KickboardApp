//
//  LoginView.swift
//  KickboardApp
//
//  Created by 강유정 on 7/22/24.
//

import UIKit

class LoginView: UIView {

    // UILabel 생성
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.text = """
                        킥
                              킥
                                    킥
                     """
        label.numberOfLines = 3 // 최대 3줄까지 허용
        label.textColor = .white
        label.font = UIFont(name: "BagelFatOne-Regular", size: 75) // 폰트 추가
        
        return label
    }()
    
    // UITextField 추가
    let idTextField: UITextField = {
        let text = UITextField()
        text.font = .systemFont(ofSize: 16)
        text.layer.cornerRadius = 18
        text.placeholder = " 이메일 주소 또는 아이디"
        text.backgroundColor = UIColor.white.withAlphaComponent(0.4) // 반투명 색상
        
        // Padding 설정
         let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
         text.leftView = paddingView
         text.leftViewMode = .always
        
        return text
    }()
    
    let passwordTextField: UITextField = {
        let text = UITextField()
        text.font = .systemFont(ofSize: 16)
        text.layer.cornerRadius = 18
        text.placeholder = " 비밀번호"
        text.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        text.isSecureTextEntry = true  // passwordTextField 마스킹
        
        // Padding 설정
         let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
         text.leftView = paddingView
         text.leftViewMode = .always
        
        return text
    }()
    
    // UILabel 생성
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 25
        button.layer.borderColor = UIColor.systemGray5.cgColor // 테두리 색상
        
        return button
    }()
    
    // UILabel 생성
    let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.setTitleColor(.placeholderText, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.4) // 반투명 색상
        button.layer.cornerRadius = 25
        
        return button
    }()
    
    // 이니셜라이저 지정
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .twPurple

        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 오토레이아웃
    private func configureUI() {
        [
            logoLabel,
            idTextField,
            passwordTextField,
            loginButton,
            signUpButton
        ].forEach { self.addSubview($0) }
        
        logoLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(110)
            $0.leading.trailing.equalToSuperview().inset(40)
        }
        
        idTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logoLabel.snp.bottom).offset(50)
            $0.leading.equalToSuperview().inset(30)
            $0.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(idTextField.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(30)
            $0.height.equalTo(50)
        }
        
        loginButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(passwordTextField.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(30)
            $0.height.equalTo(50)
        }
        
        signUpButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(loginButton.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(30)
            $0.height.equalTo(50)
        }
        
    }

}
