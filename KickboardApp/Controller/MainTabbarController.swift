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
        let firstTab = UINavigationController(rootViewController: ReturnViewController())
        let secondTab = UINavigationController(rootViewController: MapViewController())
        let thirdTab = UINavigationController(rootViewController: HistoryViewController())
        
        firstTab.tabBarItem = UITabBarItem(title: "반납하기", image: UIImage(named: "tabBarScooter"), tag: 0)
        secondTab.tabBarItem = UITabBarItem(title: "지도", image: UIImage(named: "tabBarMap"), tag: 1)
        thirdTab.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(named: "tabBarMyPage"), tag: 2)
        
        viewControllers = [firstTab, secondTab, thirdTab]
        
        tabBar.barTintColor = .white
        tabBar.tintColor = UIColor(red: 134/255, green: 74/255, blue: 238/255, alpha: 1.0)
        tabBar.unselectedItemTintColor = .lightGray
        tabBar.isTranslucent = false
        
        selectedIndex = 1
    }
}
