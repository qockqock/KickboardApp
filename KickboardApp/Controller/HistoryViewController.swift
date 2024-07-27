//
//  HistoryViewController.swift
//  KickboardApp
//
//  Created by 강유정 on 7/23/24.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController, MapViewControllerDelegate {
    
    private let historyView = HistoryView()
    
    var container: NSPersistentContainer!
    
    let imageNames = ["RandomImg1", "RandomImg2", "RandomImg3", "RandomImg4", "RandomImg5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
        
        view = historyView
        
        //        // 네비게이션
        //        self.title = "마이 페이지"
        
        historyView.imageButton.addTarget(self, action: #selector(imageButtonTapped), for: .touchUpInside)
        historyView.loginOutButton.addTarget(self, action: #selector(loginOutButtonTapped), for: .touchUpInside)
        historyView.quitButton.addTarget(self, action: #selector(quitButtonTapped), for: .touchUpInside)
        historyView.phoneChangeButton.addTarget(self, action: #selector(phoneChangeButtonTapped), for: .touchUpInside)
        historyView.dateChangeButton.addTarget(self, action: #selector(dateChangeButtonTapped), for: .touchUpInside)
        
        fetchCurrentUser()
        
        // MapViewController 인스턴스 생성 및 delegate 설정
        let mapViewController = MapViewController()
        mapViewController.delegate = self
    }
    
    // MARK: - 랜덤 이미지 버튼 - YJ
    @objc private func imageButtonTapped() {
        let randomIndex = Int.random(in: 0..<imageNames.count)
        let randomImageName = imageNames[randomIndex]
        
        historyView.profileImage.image = UIImage(named: randomImageName)
    }
    
    @objc private func phoneChangeButtonTapped() {
        
    }
    
    @objc private func dateChangeButtonTapped() {
        
    }
    
    // MARK: - 현재 유저 정보 마이페이지에 띄우기 - YJ
    func fetchCurrentUser() {
        guard let currentUserEmail = UserDefaults.standard.string(forKey: "currentUserEmail") else {
            print("사용자 이메일을 찾을 수 없습니다.")
            return
        }
        
        let fetchRequest: NSFetchRequest<Users> = NSFetchRequest(entityName: "Users")
        fetchRequest.predicate = NSPredicate(format: "email == %@", currentUserEmail)
        
        do {
            let users = try self.container.viewContext.fetch(fetchRequest)
            if let currentUser = users.first {
                if let nickname = currentUser.nickname {
                    historyView.nicknameLabel.text = "\(nickname)  님"
                }
                if let id = currentUser.id {
                    historyView.idLabel.text = "회원번호   \(id)"
                }
                if let email = currentUser.email {
                    historyView.emailLabel.text = "이메일   \(email)"
                }
            } else {
                print("해당 사용자의 데이터를 찾을 수 없습니다.")
            }
        } catch {
            print("사용자 데이터 가져오기 오류")
        }
    }
    
    // 메인페이지로 돌아가는 코드 따로 뺐습니다!! - sh
    private func returnToLoginPage() {
        if let windowScene = view.window?.windowScene {
            for window in windowScene.windows {
                if window.isKeyWindow {
                    window.rootViewController = LoginViewController()
                    UIView.transition(with: window, duration: 0.5, options: .allowAnimatedContent, animations: nil, completion: nil)
                }
            }
        }
    }
    
    // 유저 delete 메서드 - sh
    private func deleteUser(email: String) {
        let predicate = NSPredicate(format: "email == %@", email)
        CoreDataManager.shared.delete(entityType: Users.self, predicate: predicate)
    }
    
    // MARK: - 로그아웃 버튼 - YJ
    @objc private func loginOutButtonTapped() {
        UserDefaults.standard.removeObject(forKey: "currentUserEmail")
        loginOutButtonTapAlert()
    }
    
    private func loginOutButtonTapAlert() {
        self.alertManager(title: "로그아웃", message: "정말로 로그아웃 하시겠습니까?", confirmTitles: "확인", cancelTitles: "취소", confirmActions: { action in
            print("확인 버튼이 클릭되었습니다")
            self.returnToLoginPage()
        })
        
        //        let loginOutAlert = UIAlertController(title: "로그아웃", message: "정말로 로그아웃을 하시겠습니까?", preferredStyle: .alert)
        //        loginOutAlert.addAction(UIAlertAction(title: "확인", style: .cancel) { action in
        //            print("확인 버튼이 클릭되었습니다")
        //            self.returnToLoginPage()
        //        })
        //        loginOutAlert.addAction(UIAlertAction(title: "취소", style: .destructive) { action in
        //            print("취소 버튼이 클릭되었습니다")
        //        })
        //        self.present(loginOutAlert, animated: true, completion: nil)
    }
    
    // MARK: - 회원탈퇴 버튼 - sh
    @objc private func quitButtonTapped() {
        self.alertManager(title: "정말 탈퇴하시겠습니까?", message: "저장된 정보는 모두 삭제되며, 돌이킬 수 없습니댜.", confirmTitles: "예", cancelTitles: "아니오", confirmActions: { action in
            guard let currentUserEmail = UserDefaults.standard.string(forKey: "currentUserEmail") else { return }
            self.alertManager(title: "탈퇴 완료", message: "회원 탈퇴가 완료되었습니다.", confirmTitles: "확인", confirmActions: { _ in
                self.deleteUser(email: currentUserEmail)
                UserDefaults.standard.removeObject(forKey: "currentUserEmail")
                self.returnToLoginPage()})
        })
    }
    
    //        func showAlert(title: String, message: String, confirmActionTitle: String, cancelActionTitle: String?, confirmActionHandler: @escaping () -> Void) {
    //            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    //            let confirmAction = UIAlertAction(title: confirmActionTitle, style: .destructive) { _ in
    //                confirmActionHandler()
    //            }
    //            alert.addAction(confirmAction)
    //
    //            if let cancelTitle = cancelActionTitle {
    //                let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
    //                alert.addAction(cancelAction)
    //            }
    //
    //            present(alert, animated: true, completion: nil)
    //        }
    
    // MARK: - stopReturnButton 버튼 클릭 액션 - YJ
    func didTapStopReturnButton() {
        historyView.useKickboardLabel.text = "\"킥보드를 이용중 입니다.\""
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



