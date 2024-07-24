//
//  HistoryViewController.swift
//  KickboardApp
//
//  Created by 강유정 on 7/23/24.
//

import UIKit

class HistoryViewController: UIViewController {
    
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



