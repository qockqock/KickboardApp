//
//  LoginView.swift
//  KickboardApp
//
//  Created by 강유정 on 7/22/24.
//

import UIKit

class LoginView: UIView {
    
//    let customFont = UIFont(name: "BagelFatOne-Regular", size: 30)
    
    // UILabel 생성
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.text = """
                        킥
                              킥
                                    킥
                     """
        label.numberOfLines = 3 // 최대 3줄까지 허용
        label.textColor = UIColor(red: 134/255, green: 74/255, blue: 238/255, alpha: 1.0)
        label.font = UIFont(name: "BagelFatOne-Regular", size: 70) // 폰트 추가
        
        return label
    }()
    
    // UITextField 추가
    let idTextField: UITextField = {
        let text = UITextField()
        text.font = .systemFont(ofSize: 18)
        text.layer.cornerRadius = 10
        text.placeholder = " 이메일 주소 또는 아이디"
//        text.backgroundColor = .systemGray5
        text.layer.borderWidth = 2.0 // 테두리 두께
        text.layer.borderColor = UIColor.systemGray5.cgColor // 테두리 색상
        
        // Padding 설정
         let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40)) // 여기서 높이는 임의로 40으로 설정
         text.leftView = paddingView
         text.leftViewMode = .always
        
        return text
    }()
    
    let passwordTextField: UITextField = {
        let text = UITextField()
        text.font = .systemFont(ofSize: 18)
        text.layer.cornerRadius = 10
        text.placeholder = " 비밀번호"
        //        text.backgroundColor = .systemGray5
        text.layer.borderWidth = 2.0 // 테두리 두께
        text.layer.borderColor = UIColor.systemGray5.cgColor // 테두리 색상
        
        // Padding 설정
         let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40)) // 여기서 높이는 임의로 40으로 설정
         text.leftView = paddingView
         text.leftViewMode = .always
        
        return text
    }()
    
    // UILabel 생성
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.backgroundColor = UIColor(red: 134/255, green: 74/255, blue: 238/255, alpha: 1.0)
        button.setTitleColor(.systemGray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 25
//        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        return button
    }()
    
    // UILabel 생성
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .white
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 2.0 // 테두리 두께
        button.layer.borderColor = UIColor.systemGray5.cgColor // 테두리 색상
//        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        return button
    }()
    
    // 이니셜라이저 지정
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = UIColor(red: 134/255, green: 74/255, blue: 238/255, alpha: 1.0)
//        self.backgroundColor = .white
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 오토 레이아웃
    func configureUI() {
        [
            logoLabel,
            idTextField,
            passwordTextField,
            loginButton,
            signUpButton
        ].forEach { self.addSubview($0) }
        
        logoLabel.snp.makeConstraints {
            //            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(120)
            $0.leading.trailing.equalToSuperview().inset(40)
            //            $0.width.equalTo(0)
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
