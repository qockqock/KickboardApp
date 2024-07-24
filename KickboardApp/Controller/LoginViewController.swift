//
//  LoginViewController.swift
//  KickboardApp
//
//  Created by 김승희 on 7/22/24.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    
    private let loginView = LoginView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        view = loginView
        loginView.loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        loginView.signUpButton.addTarget(self, action: #selector(signUpbuttonTapped), for: .touchUpInside)
    }
    
    @objc func handleLogin() {
        // 로그인 로직 처리 후에 붙여주세요!! - sh
        if let windowScene = view.window?.windowScene {
            for window in windowScene.windows {
                if window.isKeyWindow {
                    window.rootViewController = MainTabbarController()
                    UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
                }
            }
        }
    }
    
    @objc func signUpbuttonTapped() {
        self.navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
}
