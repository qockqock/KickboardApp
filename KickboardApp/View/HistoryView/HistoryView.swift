//
//  HistoryView.swift
//  KickboardApp
//
//  Created by 임혜정 on 7/28/24.
//

import UIKit
import SnapKit


class HistoryView: UIView {
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "historyBackground")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let detailUse : UILabel = {
        let label = UILabel()
        label.text = "이용 내역"
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        return label
    }()

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.backgroundColor = .systemGray6
        tableView.alpha = 1.0 // 테이블 뷰의 투명도 설정 예시
        return tableView
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHistoryUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupHistoryUI() {
        self.backgroundColor = .gray
        [backgroundImageView, detailUse, tableView].forEach {
            self.addSubview($0)
        }
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        detailUse.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(100)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(40)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(detailUse.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.height.equalTo(200)
        }
    }
}
