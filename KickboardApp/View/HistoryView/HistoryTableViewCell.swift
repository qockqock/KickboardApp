//
//  HistoryTableViewCell.swift
//  KickboardApp
//
//  Created by 강유정 on 7/23/24.
//

import UIKit
import SnapKit

final class TableViewCell: UITableViewCell {

    private let rideDatelabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    private let rideTimelabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    private let ridePaymentlabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    private let kickboardIdLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    private let historyCellView: UIView = {
        let view = UIView()
        
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {

        [historyCellView].forEach { contentView.addSubview($0)}
        
        [
            rideDatelabel,
            rideTimelabel,
            ridePaymentlabel,
            kickboardIdLabel,
            
        ].forEach { historyCellView.addSubview($0) }
        
        historyCellView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        
        rideDatelabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(15)
            $0.top.equalTo(10)
            $0.trailing.equalToSuperview().inset(15)
        }

        rideTimelabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(15)
            $0.top.equalTo(rideDatelabel.snp.bottom).offset(5)
            $0.trailing.equalToSuperview().inset(15)
        }

        ridePaymentlabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(15)
            $0.top.equalTo(rideTimelabel.snp.bottom).offset(5)
            $0.trailing.equalToSuperview().inset(15)
        }

        kickboardIdLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(15)
            $0.top.equalTo(ridePaymentlabel.snp.bottom).offset(5)
            $0.trailing.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview().inset(10)
        }

    }
    
    func configureCell(rideData: RideData) {
        // 날짜를 문자열로 변환
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium // 원하는 형식으로 설정
        dateFormatter.timeStyle = .short
        
        let formattedDate = dateFormatter.string(from: rideData.date ?? Date())
        
        // 숫자를 금액 단위로 변경
        func formatNumber(_ fae: Int) -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter.string(from: NSNumber(value: fae)) ?? "\(fae)"
        }
        
        let fae = "\(formatNumber(Int(rideData.fee)))"
        
        // UUID를 문자열로 변환하고 기본값 설정
        let formattedKickboardId = rideData.kickboardId?.uuidString ?? "킥보드 ID 없음"

        // 셀의 레이블에 값 설정
        rideDatelabel.text = "이용날짜:  \(formattedDate)"
        rideTimelabel.text = "이용시간:  \(rideData.distance ?? "시간 없음")"
        ridePaymentlabel.text = "이용금액:  \(fae)원"
        kickboardIdLabel.text = "내가 등록한 킥보드:  \(formattedKickboardId)"
    }
}
