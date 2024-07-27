//
//  MapView.swift
//  KickboardApp
//
//  Created by 임혜정 on 7/24/24.
//

import UIKit
import SnapKit
import KakaoMapsSDK

class MapView: UIView {

    lazy var mapView: KMViewContainer = {
        let view = KMViewContainer()
        return view
    }()
    
    lazy var stopReturnButton: UIButton = {
        let button = UIButton()
        button.setTitle("대여하기", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = .purple
        button.isEnabled = false // 처음에는 비활성화
        button.layer.cornerRadius = 10
        return button
    }()
    
    lazy var myLocationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("위치", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        return button
    }()
    
    lazy var returnPointLabel: UILabel = {
        let label = UILabel()
        label.text = "목적지를 설정해주세요"
        label.textAlignment = .center
        label.backgroundColor = .white
        label.textColor = .black
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 2, height: 2)
        label.layer.shadowOpacity = 0.6
        
        label.isHidden = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        mapSetupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - auto layout
    func mapSetupUI() {
        backgroundColor = .white
        
        [mapView, stopReturnButton, myLocationButton].forEach {
            self.addSubview($0)
        }
        
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stopReturnButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(180)
            $0.height.equalTo(50)
        }
        
        myLocationButton.snp.makeConstraints {
            $0.bottom.equalTo(stopReturnButton.snp.top).offset(-30)
            $0.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-20)
            $0.width.equalTo(50)
            $0.height.equalTo(50)
        }
        
        self.addSubview(returnPointLabel)
        
        returnPointLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(200)
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.height.equalTo(50)
        }
    }
}
