//
//  SignUpViewController.swift
//  KickboardApp
//
//  Created by 김승희 on 7/22/24.
//

import UIKit
import SnapKit

class SignUpViewController: UIViewController {
    private let signUpView = SignUpView()
    
    // MARK: - 뷰디드로드
    override func viewDidLoad() {
        super.viewDidLoad()
        view = signUpView
        view.backgroundColor = .white
        signUpView.checkIdButton.addTarget(self, action: #selector(checkIdButtonTap), for: .touchDown)
        signUpView.membershipJoinButton.addTarget(self, action: #selector(membershipJoinButtonTap), for: .touchDown)
    }
    
    // MARK: - 유저의 이메일을 확인하는란
    private func userEmailCheck(_ email: String) -> Bool {
        let emailRegularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let userEmailTest = NSPredicate(format: "SELF MATCHES %@", emailRegularExpression)
        return userEmailTest.evaluate(with: email)
    }
    
    // MARK: - 중복확인 얼럿
    @objc private func checkIdButtonTap() {
        print("중복확인 버튼이 클릭 되었습니다.")
        guard let email = signUpView.userIdText.text else { return }
        if userEmailCheck(email) {
            let checkIdButtonTapAlert = UIAlertController(title: "사용가능한 아이디", message: "해당 아이디로 가입을 하시겠습니까?", preferredStyle: .alert)
            print("중복확인 버튼 얼럿이 열렸습니다.")
            checkIdButtonTapAlert.addAction(UIAlertAction(title: "취소", style: .destructive) { action in
                print("취소 버튼이 클릭되었습니다")
            })
            
            checkIdButtonTapAlert.addAction(UIAlertAction(title: "확인", style: .default) { action in
                print("확인 버튼이 클릭되었습니다")
                self.checkIdButtonTapAlerts()
            })
            self.present(checkIdButtonTapAlert, animated: true, completion: nil)
            // 이메일 형식이 아닐때 뜨는 얼럿
        } else {
            let nonEmailIdAlert = UIAlertController(title: "이메일 형식이 다릅니다", message: "이메일의 형식으로 다시 확인해 주세요", preferredStyle: .alert)
            print("이메일 형식이 다른 얼럿이 열렸습니다")
            nonEmailIdAlert.addAction(UIAlertAction(title: "확인", style: .destructive) { action in
                print("확인 버튼이 클릭되었습니다")
            })
            self.present(nonEmailIdAlert, animated: true, completion: nil)
        }
    }
    
    //확인시 2중 얼럿
    private func checkIdButtonTapAlerts() {
        let checkDoubleAlert = UIAlertController(title: "축하합니다", message: "중복확인을 모두 마치었습니다.", preferredStyle: .alert)
        checkDoubleAlert.addAction(UIAlertAction(title: "확인", style: .default) { action in
            print("확인 버튼이 클릭되었습니다")
        })
        self.present(checkDoubleAlert, animated: true, completion: nil)
    }
    
    // MARK: - 회원가입 얼럿
    @objc private func membershipJoinButtonTap() {
        print("회원가입 버튼이 클릭 되었습니다.")
        let membershipAlert = UIAlertController(title: "회원가입 완료", message: "킥킥킥 서비스에 회원가입을 해주셔서 감사합니다 많은 이용 부탁드립니다🎉.", preferredStyle: .alert)
        print("회원가입 얼럿창이 열렸습니다.")
        
        membershipAlert.addAction(UIAlertAction(title: "확인", style: .default) { action in
            print("확인 버튼이 클릭되었습니다")
            
        })
        
        self.present(membershipAlert, animated: true, completion: nil)
    }
}
