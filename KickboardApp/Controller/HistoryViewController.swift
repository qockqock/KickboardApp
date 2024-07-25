//
//  HistoryViewController.swift
//  KickboardApp
//
//  Created by 강유정 on 7/23/24.
//

import UIKit

class HistoryViewController: UIViewController {
    
    private let historyView = HistoryView()
    
    let imageNames = ["RandomImg1", "RandomImg2", "RandomImg3", "RandomImg4", "RandomImg5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = historyView
        
        // 네비게이션
        self.title = "마이 페이지"
        
        historyView.imageButton.addTarget(self, action: #selector(imageButtonTapped), for: .touchUpInside)
        historyView.loginOutButton.addTarget(self, action: #selector(loginOutButtonTapped), for: .touchUpInside)
    }
   
    // MARK: - 네이게이션 타이틀 - YJ
    private func navigationSet() {
        self.title = "마이 페이지"
    }
    
    // MARK: - 랜덤 이미지 버튼 - YJ
    @objc private func imageButtonTapped() {
        let randomIndex = Int.random(in: 0..<imageNames.count)
        
        let randomImageName = imageNames[randomIndex]
        
        historyView.profileImage.image = UIImage(named: randomImageName)
    }
    
    // MARK: - 로그아웃 - YJ
    @objc private func loginOutButtonTapped() {
        if let windowScene = view.window?.windowScene {
            for window in windowScene.windows {
                if window.isKeyWindow {
                    window.rootViewController = LoginViewController()
                    UIView.transition(with: window, duration: 0.5, options: .allowAnimatedContent, animations: nil, completion: nil)
                }
            }
        }
    }
}

//extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        // 로직 구현
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // 행이 몇개 들어가는지 로직 구현
//    }
//}



