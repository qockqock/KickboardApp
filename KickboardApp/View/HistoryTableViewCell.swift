//
//  HistoryTableViewCell.swift
//  KickboardApp
//
//  Created by 강유정 on 7/23/24.
//

import UIKit

final class TableViewCell: UITableViewCell {
    
    private let rideDatelabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .black
        label.textColor = .white
        label.numberOfLines = 0 // 여러 줄 허용
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()
    
    private let rideTimelabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .black
        label.textColor = .white
        label.numberOfLines = 0 // 여러 줄 허용
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()
    
    private let ridePaymentlabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .black
        label.textColor = .white
        label.numberOfLines = 0 // 여러 줄 허용
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.backgroundColor = .black
        [
            rideDatelabel,
            rideTimelabel,
            ridePaymentlabel
        ].forEach { contentView.addSubview($0) }
        
        rideDatelabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        rideTimelabel.snp.makeConstraints {
            $0.trailing.equalTo(rideDatelabel.snp.bottom).inset(20)
            $0.centerY.equalToSuperview()
        }
        
        ridePaymentlabel.snp.makeConstraints {
            $0.trailing.equalTo(rideTimelabel.snp.bottom).inset(20)
            $0.centerY.equalToSuperview()
        }
    }
    
    // 데이터 설정 메서드
    func configureCell(rideData: RideData) {
        // Date를 문자열로 변환하기 위해 DateFormatter 사용
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd " // 날짜 포맷 설정 (원하는 형식으로 변경)
        
//        rideDatelabel.text = rideData.date
//        rideTimelabel.text = rideData.distance
//        ridePaymentlabel.text = rideData.fee

    }
    
}
