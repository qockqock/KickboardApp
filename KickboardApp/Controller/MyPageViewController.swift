//
//  MyPageViewController.swift
//  KickboardApp
//
//  Created by 강유정 on 7/23/24.
//

import UIKit
import CoreData

class MyPageViewController: UIViewController, MapViewControllerDelegate {
    
    private let historyView = MyPageView()
    
    private var rideDataArray: [RideData] = []
    
    var container: NSPersistentContainer!
    
    let imageNames = ["RandomImg1", "RandomImg2", "RandomImg3", "RandomImg4", "RandomImg5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
        
        view = historyView
        
        // 네비게이션 바 타이틀 설정
        self.title = "마이페이지"
        
        // 버튼 클릭 이벤트 핸들러 설정
        historyView.imageButton.addTarget(self, action: #selector(imageButtonTapped), for: .touchUpInside)
        historyView.loginOutButton.addTarget(self, action: #selector(loginOutButtonTapped), for: .touchUpInside)
        historyView.quitButton.addTarget(self, action: #selector(quitButtonTapped), for: .touchUpInside)
        historyView.detailUseButton.addTarget(self, action: #selector(detailUseButtonTapped), for: .touchUpInside)
        historyView.phoneChangeButton.addTarget(self, action: #selector(phoneChangeButtonTapped), for: .touchUpInside)
        historyView.dateChangeButton.addTarget(self, action: #selector(dateChangeButtonTapped), for: .touchUpInside)
        
        fetchCurrentUser()
        
        // MapViewController 인스턴스 생성 및 delegate 설정
        let mapViewController = MapViewController()
        mapViewController.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    // MARK: - 랜덤 이미지 버튼 - YJ
    @objc private func imageButtonTapped() {
        let randomIndex = Int.random(in: 0..<imageNames.count)
        let randomImageName = imageNames[randomIndex]
        
        historyView.profileImage.image = UIImage(named: randomImageName)
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
                    let loginViewController = LoginViewController() // <- 요게 문제였음!
                    let navigationController = UINavigationController(rootViewController: loginViewController)
                    window.rootViewController = navigationController
                    UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
                }
            }
        }
    }
    
    // 유저 delete 메서드 - sh
    private func deleteUser(email: String) {
        let predicate = NSPredicate(format: "email == %@", email)
        CoreDataManager.shared.delete(entityType: Users.self, predicate: predicate)
    }

    @objc private func phoneChangeButtonTapped() {
        showEditAlert(
            title: "휴대폰 번호를 입력하세요.",
            placeholder: "새로운 휴대폰 번호",
            currentText: historyView.phoneNumberLabel.text ?? ""
        ) { newText in
            self.historyView.phoneNumberLabel.text = "휴대폰  \(newText)"
        }
    }

    @objc private func dateChangeButtonTapped() {
        showEditAlert(
            title: "생년월일을 입력하세요.",
            placeholder: "새로운 생년월일",
            currentText: historyView.birthDateLabel.text ?? ""
        ) { newText in
            self.historyView.birthDateLabel.text = "생년월일  \(newText)"
        }
    }
    
    // MARK: - 로그아웃 버튼 - YJ
    @objc private func loginOutButtonTapped() {
        UserDefaults.standard.removeObject(forKey: "currentUserEmail")
        loginOutButtonTapAlert()
    }
    
    // MARK: - 로그아웃 버튼 - YJ
    @objc private func detailUseButtonTapped() {
        self.navigationController?.pushViewController(HistoryViewController(), animated: true)
    }
    
    private func loginOutButtonTapAlert() {
        self.alertManager(title: "로그아웃", message: "정말로 로그아웃 하시겠습니까?", confirmTitles: "확인", cancelTitles: "취소", confirmActions: { action in
            print("확인 버튼이 클릭되었습니다")
            self.returnToLoginPage()
        })
        
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
    
    // MARK: - stopReturnButton 버튼 클릭 액션 - YJ
    func didTapStoprentalButton() {
           historyView.useKickboardLabel.text = "\"킥보드를 이용중 입니다.\""
       }
    func didTapStopReturnButton() {
        historyView.useKickboardLabel.text = "\"킥보드를 이용하고 있지 않습니다.\""
    }
    
}

extension MyPageViewController {
    private func showEditAlert(title: String, placeholder: String, currentText: String, completion: @escaping (String) -> Void) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
             // 기본값을 설정하지 않고 빈 상태로 만듭니다.
             textField.text = ""
             textField.placeholder = placeholder
        }
        
        let confirmAction = UIAlertAction(title: "변경", style: .default) { _ in
            if let newText = alertController.textFields?.first?.text {
                completion(newText)
            }
        }
        alertController.addAction(confirmAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

