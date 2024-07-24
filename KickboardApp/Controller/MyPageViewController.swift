//
//  MyPageViewController.swift
//  KickboardApp
//
//  Created by 김승희 on 7/22/24.
//

import UIKit

class MyPageViewController: UIViewController {
    
    private let historyView = HistoryView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = historyView
        navigationSet()

    }
    
    private func navigationSet() {
        self.title = "마이 페이지"
    }
    
    
}
