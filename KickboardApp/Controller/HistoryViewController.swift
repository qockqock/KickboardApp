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

        historyView.imageButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    private func navigationSet() {
        self.title = "마이 페이지"
    }
    
    @objc
    private func buttonTapped() {
        let randomIndex = Int.random(in: 0..<imageNames.count)
        
        let randomImageName = imageNames[randomIndex]
        
        historyView.profileImage.image = UIImage(named: randomImageName)
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



