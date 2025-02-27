//
//  MainTabbarController.swift
//  KickboardApp
//
//  Created by 김승희 on 7/23/24.
//

import UIKit

class MainTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbar()
    }
    
    // Tabbar 생성하는 메서드 - sh
    func setupTabbar() {
        // 델리게이트를 위한 변수 설정 - YJ
        let mapviewController = MapViewController()
        let myPageController = MyPageViewController()
        
        mapviewController.delegate = myPageController
        
        let firstTab = ReturnViewController.timer
        let secondTab = mapviewController
        
        // 네비게이션 컨트롤러로 감싸기
         let thirdTab = UINavigationController(rootViewController: myPageController)

        firstTab.tabBarItem = UITabBarItem(title: "반납하기", image: UIImage(named: "tabBarScooter"), tag: 0)
        secondTab.tabBarItem = UITabBarItem(title: "지도", image: UIImage(named: "tabBarMap"), tag: 1)
        thirdTab.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(named: "tabBarMyPage"), tag: 2)
        
        viewControllers = [firstTab, secondTab, thirdTab]
        
        tabBar.barTintColor = .white
        tabBar.tintColor = .twPurple
        tabBar.unselectedItemTintColor = .lightGray
        tabBar.isTranslucent = false
        
        selectedIndex = 1
    }
}
