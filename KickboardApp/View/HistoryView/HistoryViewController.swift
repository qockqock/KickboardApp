//
//  HistoryViewController.swift
//  KickboardApp
//
//  Created by 임혜정 on 7/28/24.
//

import UIKit
import CoreData
import SnapKit

class HistoryViewController: UIViewController {
    
    var historyView = HistoryView()
    private var rideDataArray: [RideData] = []
    var container: NSPersistentContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = historyView
        // Configure the table view
        historyView.tableView.dataSource = self
        historyView.tableView.delegate = self
        historyView.tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        fetchRideData()
    }
    
    // MARK: - 코어데이터에서 데이터 조회하고 테이블뷰 업데이트 - YJ
    func fetchRideData() {
        guard let currentUserEmail = UserDefaults.standard.string(forKey: "currentUserEmail") else {
            print("현재 사용자 이메일을 찾을 수 없습니다.")
            return
        }
        
        let fetchRequest: NSFetchRequest<RideData> = RideData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", currentUserEmail)
        
        do {
            // Core Data에서 RideData를 가져오기
            let rideData = try self.container.viewContext.fetch(fetchRequest)
            self.rideDataArray = rideData // rideDataArray를 업데이트
            
            // 테이블 뷰를 갱신
            historyView.tableView.reloadData()
        } catch {
            print("RideData를 가져오는 데 오류가 발생했습니다.")
        }
    }

}


// MARK: - 테이블뷰 설정 - YJ
extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rideDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let rideData = rideDataArray[indexPath.row]
        cell.configureCell(rideData: rideData)
        cell.backgroundColor = .systemGray6
        
        // 선택해도 색이 바뀌지 않도록 설정
        cell.selectionStyle = .none
        
        return cell
    }
}
