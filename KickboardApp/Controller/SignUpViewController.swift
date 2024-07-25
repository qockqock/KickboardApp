//
//  SignUpViewController.swift
//  KickboardApp
//
//  Created by 김승희 on 7/22/24.
//

import UIKit
import SnapKit
import CoreData

class SignUpViewController: UIViewController, UITextFieldDelegate {
    private let signUpView = SignUpView()
    //코어데이터에 저장하기 위한 필수 구현
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - 뷰디드로드
    
    func printAllUsers() { CoreDataManager.shared.read(entityType: Users.self) {
        user in
        if let id = user.id, let nickname = user.nickname, let email = user.email, let password = user.password, let date = user.date, let image = user.image { print("User ID: \(id), Nickname: \(nickname), Email: \(email), Password: \(password), Date: \(date), Image: \(image)") } } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = signUpView
        view.backgroundColor = .white
        signUpView.checkIdButton.addTarget(self, action: #selector(checkIdButtonTap), for: .touchDown)
        signUpView.membershipJoinButton.addTarget(self, action: #selector(membershipJoinButtonTap), for: .touchDown)
        signUpView.userPassWordText.delegate = self
        signUpView.userPassWordCheckText.delegate = self
        printAllUsers()
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
            let nonEmailIdAlert = UIAlertController(title: "아이디 확인", message: (signUpView.userIdText.text?.isEmpty ?? true) ? "이메일 주소창이 비어 있습니다." : "이메일의 형식을 확인해주세요.", preferredStyle: .alert)
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
        guard let userId = signUpView.userIdText.text, !userId.isEmpty else {
            self.textFieldCheck(textField: signUpView.userIdText, type: "아이디")
            return
        }
        
        guard let password = signUpView.userPassWordText.text, !password.isEmpty else {
            self.textFieldCheck(textField: signUpView.userPassWordText, type: "비밀번호")
            return
        }
        
        guard let passwordCheck = signUpView.userPassWordCheckText.text, !passwordCheck.isEmpty else {
            self.textFieldCheck(textField: signUpView.userPassWordCheckText, type: "비밀번호 확인")
            return
        }
        
        guard let nickname = signUpView.userNickNameText.text, !nickname.isEmpty else {
            self.textFieldCheck(textField: signUpView.userNickNameText, type: "닉네임")
            return
        }
        
        if userId.count < 8 {
            self.membershipshowAlert(title: "아이디 오류", message: "이메일 형식이 잘못되었거나 또는 아이디는 최소 8자 이상이어야 합니다.")
            return
        }
        
        if !self.passwordCheck(password) {
            self.membershipshowAlert(title: "비밀번호 오류", message: "비밀번호는 최소 8자 이상이며, 하나 이상의 문자, 숫자, 특수문자가 포함되어야 합니다.")
            return
        }
        
        if password != passwordCheck {
            self.membershipshowAlert(title: "비밀번호 확인 오류", message: "비밀번호와 비밀번호 확인이 일치하지 않습니다.")
            return
        }
        
        if nickname.count < 2 {
            self.membershipshowAlert(title: "닉네임 오류", message: "닉네임은 최소 2자 이상이어야 합니다.")
            return
        }
        
        // Core Data에 사용자 정보 저장
        let user = Users(context: context)
        user.id = UUID()
        user.email = userId
        user.nickname = nickname
        user.password = password
        user.image = "asdf"
        user.date = Date()
        
        do {
            try context.save()
            
            let membershipAlert = UIAlertController(title: "회원가입 완료", message: "킥킥킥 서비스에 회원가입을 해주셔서 감사합니다 많은 이용 부탁드립니다🎉.", preferredStyle: .alert)
            print("회원가입 얼럿창이 열렸습니다.")
            
            membershipAlert.addAction(UIAlertAction(title: "확인", style: .default) { action in
                print("확인 버튼이 클릭되었습니다")
            })
            
            self.present(membershipAlert, animated: true, completion: nil)
            // 회원가입 실패시
        } catch {
            self.membershipshowAlert(title: "회원가입 실패", message: "회원가입 중 오류가 발생했습니다. 다시 시도해주세요.")
        }
    }
    // MARK: - 비밀번호 텍스트필드
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == signUpView.userPassWordText || textField == signUpView.userPassWordCheckText {
            // 변경된 텍스트로 새 비밀번호를 생성
            let newPassword = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
            _ = userPassWordCheckPoint(password: newPassword)
            let password1 = textField == signUpView.userPassWordText ? newPassword : signUpView.userPassWordText.text ?? ""
            let password2 = textField == signUpView.userPassWordCheckText ? newPassword : signUpView.userPassWordCheckText.text ?? ""
            checkPasswordsMatch(password1: password1, password2: password2)
        }
        return true
    }
    
    // 비밀번호 체크 포인트 메서드
    private func userPassWordCheckPoint(password: String) -> Bool {
        if passwordCheck(password) {
            print("비밀번호의 형식이 맞습니다")
            signUpView.userPassWord.text = "사용 가능한 비밀번호 ✅"
            print("정규표현식을 통과했습니다.")
        } else {
            signUpView.userPassWord.text = "비밀번호"
        }
        return true
    }
    
    // 비밀번호 유효성 검사 메서드
    private func passwordCheck(_ password: String) -> Bool {
        print("비밀번호의 정규표현이 맞는지 확인합니다")
        let passwordRegularExpression = "^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#\\$%\\^&\\*]).{8,}$" // 비밀번호 정규표현식 {8,}$ 가 8자리 이상을 표기함
        let passwordtest = NSPredicate(format: "SELF MATCHES %@", passwordRegularExpression)
        return passwordtest.evaluate(with: password)
    }
    
    // MARK: - 비밀번호확인 텍스트필드
    private func checkPasswordsMatch(password1: String, password2: String) {
        if password1 == password2 {
            signUpView.passWordCheck.text = "비밀번호가 일치합니다✅"
            signUpView.passWordCheck.textColor = .blue // 비밀번호 일치 시 색상이 파란색으로 설정
        } else {
            signUpView.passWordCheck.text = "비밀번호를 확인해주세요!"
            signUpView.passWordCheck.textColor = .red // 비밀번호 불일치 시 색상을 빨간색으로 설정
        }
    }
    
    // MARK: - UItextField가 값이 없을때 날리는 얼럿통합창
    private func textFieldCheck(textField: UITextField, type: String) {
        if textField.text == nil || textField.text == "" {
            let nickNameAlert = UIAlertController(title: "\(type)를 입력해주세요", message: "\(type) 세팅이 안되어있습니다 다시한번 확인 해주세요.", preferredStyle: .alert)
            print("얼럿창이 열렸습니다.")
            
            nickNameAlert.addAction(UIAlertAction(title: "확인", style: .default) { action in
                print("확인 버튼이 클릭되었습니다")
            })
            
            self.present(nickNameAlert, animated: true, completion: nil)
        }
    }
    
    // MARK: - 회원가입의 제약조건에 실패했을 경우
    private func membershipshowAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
