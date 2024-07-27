//
//  NextView.swift
//  sfaete
//
//  Created by 신상규 on 7/22/24.
//

import UIKit
import SnapKit

class SignUpView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        signUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 아이디
    private let userId: UILabel = {
        let userId = UILabel()
        userId.text = "아이디 / 이메일주소"
        userId.textColor = .black
        userId.font = .boldSystemFont(ofSize: 15)
        return userId
    }()
    
    public let userIdText: UITextField = {
        let userIdText = UITextField()
        userIdText.textColor = .black
        userIdText.borderStyle = .roundedRect
        userIdText.resignFirstResponder()
        userIdText.autocapitalizationType = .none
        userIdText.placeholder = "이메일주소를 입력하세요"
        return userIdText
    }()
    
    // MARK: - 중복확인 버튼
    public lazy var checkIdButton: UIButton = {
        let checkIdButton = UIButton()
        checkIdButton.setTitle("중복확인", for: .normal)
        checkIdButton.backgroundColor = .twPurple
        checkIdButton.layer.cornerRadius = 15
        return checkIdButton
    }()
    
    // MARK: - 비밀번호
    public let userPassWord: UILabel = {
        let userPassWord = UILabel()
        userPassWord.text = "비밀번호"
        userPassWord.textColor = .black
        userPassWord.font = .boldSystemFont(ofSize: 15)
        return userPassWord
    }()
    
    public let userPassWordText: UITextField = {
        let userPassWordText = UITextField()
        userPassWordText.textColor = .black
        userPassWordText.borderStyle = .roundedRect
        userPassWordText.isSecureTextEntry = true
        userPassWordText.textContentType = .oneTimeCode
        userPassWordText.resignFirstResponder()
        userPassWordText.placeholder = "비밀번호를 입력하세요"
        return userPassWordText
    }()
    
    private let checkLabel: UILabel = {
        let checkLabel = UILabel()
        checkLabel.text = "영문, 숫자, 특수문자를 포함하여 8자~12자 사이의 비밀번호를 입력해주세요."
        checkLabel.numberOfLines = 2
        checkLabel.textColor = .gray
        checkLabel.font = .boldSystemFont(ofSize: 13)
        return checkLabel
    }()
    
    public let userPassWordCheck: UILabel = {
        let userPassWordCheck = UILabel()
        userPassWordCheck.text = "비밀번호 확인"
        userPassWordCheck.textColor = .black
        return userPassWordCheck
    }()
    
    public let userPassWordCheckText: UITextField = {
        let userPassWordCheckText = UITextField()
        userPassWordCheckText.textColor = .black
        userPassWordCheckText.borderStyle = .roundedRect
        userPassWordCheckText.isSecureTextEntry = true
        userPassWordCheckText.textContentType = .oneTimeCode
        userPassWordCheckText.resignFirstResponder()
        userPassWordCheckText.placeholder = "동일한 비밀번호를 입력해주세요"
        return userPassWordCheckText
    }()
    
    public let passWordCheck: UILabel = {
        let passWordCheck = UILabel()
        passWordCheck.text = "비밀번호를 확인해주세요!"
        passWordCheck.textColor = .red
        passWordCheck.font = .boldSystemFont(ofSize: 13)
        return passWordCheck
    }()
    
    // MARK: - 닉네임
    private let userNickName: UILabel = {
        let userNickName = UILabel()
        userNickName.text = "닉네임"
        userNickName.textColor = .black
        userNickName.layer.cornerRadius = 15
        return userNickName
    }()
    
    public let userNickNameText: UITextField = {
        let userNickNameText = UITextField()
        userNickNameText.textColor = .black
        userNickNameText.borderStyle = .roundedRect
        userNickNameText.placeholder = "닉네임을 입력하세요"
        return userNickNameText
    }()
    
    public lazy var membershipJoinButton: UIButton = {
        let membershipJoinButton = UIButton()
        membershipJoinButton.setTitle("회 원 가 입", for: .normal)
        membershipJoinButton.backgroundColor = .twPurple
        membershipJoinButton.layer.cornerRadius = 30
        return membershipJoinButton
    }()
    
    // MARK: - 각종 레이블 및 버튼, 텍스트필드 오토레이아웃 구간
    private func signUpLayout() {
        
        [userId, userIdText, checkIdButton, userPassWord, userPassWordText, checkLabel, userPassWordCheck, userPassWordCheckText, passWordCheck, userNickName, userNickNameText, membershipJoinButton].forEach{ self.addSubview($0) }
        
        userId.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(150)
            $0.leading.equalTo(40)
        }
        
        userIdText.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(userId.snp.bottom).offset(10)
            $0.width.equalTo(320)
        }
        
        checkIdButton.snp.makeConstraints{
            $0.top.equalTo(userIdText.snp.bottom).offset(10)
            $0.width.equalTo(90)
            $0.leading.equalTo(40)
        }
        
        userPassWord.snp.makeConstraints{
            $0.top.equalTo(checkIdButton.snp.bottom).offset(40)
            $0.leading.equalTo(40)
        }
        
        userPassWordText.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(userPassWord.snp.bottom).offset(10)
            $0.width.equalTo(320)
        }
        
        checkLabel.snp.makeConstraints{
            $0.top.equalTo(userPassWordText.snp.bottom).offset(10)
            $0.leading.equalTo(40)
            $0.width.equalTo(300)
        }
        
        userPassWordCheck.snp.makeConstraints{
            $0.top.equalTo(checkLabel.snp.bottom).offset(40)
            $0.leading.equalTo(40)
        }
        
        userPassWordCheckText.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(userPassWordCheck.snp.bottom).offset(10)
            $0.width.equalTo(320)
        }
        
        passWordCheck.snp.makeConstraints{
            $0.top.equalTo(userPassWordCheckText.snp.bottom).offset(10)
            $0.leading.equalTo(40)
        }
        
        userNickName.snp.makeConstraints{
            $0.top.equalTo(passWordCheck.snp.bottom).offset(40)
            $0.leading.equalTo(40)
        }
        
        userNickNameText.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(userNickName.snp.bottom).offset(10)
            $0.width.equalTo(320)
        }
        
        membershipJoinButton.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(userNickNameText.snp.bottom).offset(70)
            $0.width.equalToSuperview().offset(-70)
            $0.height.equalTo(60)
        }
    }
}
