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
    
//    var mapSearchBar: UISearchBar = {
//        let searchBar = UISearchBar()
//        searchBar.placeholder = "위치 검색"
//        searchBar.backgroundColor = .white
//        searchBar.layer.cornerRadius = 10
//        searchBar.clipsToBounds = true
//        return searchBar
//    }()
    
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
        
        [mapView,  stopReturnButton, myLocationButton].forEach {
            self.addSubview($0)
        }
        
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
//        mapSearchBar.snp.makeConstraints {
//            $0.top.equalToSuperview().offset(80)
//            $0.leading.trailing.equalToSuperview().inset(20)
//            $0.height.equalTo(40)
//        }
        
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
    } 
}
