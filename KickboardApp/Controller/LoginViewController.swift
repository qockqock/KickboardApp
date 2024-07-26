//
//  LoginViewController.swift
//  KickboardApp
//
//  Created by 김승희 on 7/22/24.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    private let loginView = LoginView()
    
    var container: NSPersistentContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
        
        view.backgroundColor = .white
        
        view = loginView
        
        loginView.loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        loginView.signUpButton.addTarget(self, action: #selector(signUpbuttonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        readAllData()
    }
    
    // MARK: - email과 password 확인해서 로그인 or 회원가입 이동 - YJ
    @objc func handleLogin() {
        // 입력한 아이디와 패스워드 가져오기
        guard let email = loginView.idTextField.text, !email.isEmpty,
              let password = loginView.passwordTextField.text, !password.isEmpty else {
            showAlert(title: "알림", message: "아이디와 패스워드를 모두 입력해주세요.")
            // 두 필드 중 하나라도 비어 있을 경우 알럿
            return
        }
        
        // 데이터베이스에서 유저 정보 확인
        let fetchRequest: NSFetchRequest<Users> = NSFetchRequest(entityName: "Users")
        fetchRequest.predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)
        
        do {
            let results = try self.container.viewContext.fetch(fetchRequest)
            if results.count > 0 {
                // 이미 존재하는 유저 정보일 경우
                if let windowScene = view.window?.windowScene {
                    for window in windowScene.windows {
                        if window.isKeyWindow {
                            window.rootViewController = MainTabbarController()
                            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
                        }
                    }
                }
                
                // 로그인하면 현재 유저 이메일 저장
                let currentUserEmail = loginView.idTextField.text
                UserDefaults.standard.set(currentUserEmail, forKey: "currentUserEmail")
                
            } else {
                // 존재하지 않는 유저일 경우
                showAlert(title: "알림", message: "등록되지 않은 사용자입니다. 회원가입 해주세요.")
            }
        } catch {
            print("데이터 조회 실패")
            showAlert(title: "알림", message: "데이터 조회 실패")
        }
    }
    
    // MARK: - 회원가입 버튼 - YJ
    @objc func signUpbuttonTapped() {
        self.navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
    // MARK: - 알럿 메서드 - YJ
    // 알림 표시 메서드
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // CoreData에서 모든 사용자 데이터 읽어오기
    func readAllData() {
        do {
            let users = try self.container.viewContext.fetch(Users.fetchRequest()) as! [Users]
            
            for user in users {
                if let email = user.email, let password = user.password, let id = user.id, let date = user.date {
                    print("email: \(email), password: \(password)")
                    print("id: \(id), date: \(date)")
                }
            }
            
        } catch {
            print("데이터 읽기 실패")
        }
    }
}

