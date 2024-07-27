//
//  SearchMapView.swift
//  KickboardApp
//
//  Created by 김승희 on 7/25/24.
//

import UIKit
import SnapKit

// 뷰-컨트롤러간 데이터 전달 Delegate - sh
protocol SearchMapViewDelegate: AnyObject {
    func didSearchAddress(_ address: String)
}

class SearchMapView: UIView {
    
    weak var delegate: SearchMapViewDelegate?
    
    let textField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "도로명/지번 주소로 검색해주세요."
        textfield.borderStyle = .roundedRect
        textfield.isEnabled = true
        return textfield
    }()
    
    let searchButton: UIButton = {
        let button = UIButton(type: .custom)
        if let image = UIImage(named: "MapSearchButton") {
            button.setImage(image, for: .normal)
        }
        button.isEnabled = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        [textField, searchButton].forEach {
            self.addSubview($0)
        }
        
        textField.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview()
            $0.width.equalTo(180)
            $0.height.equalTo(50)
        }
        
        searchButton.snp.makeConstraints {
            $0.centerY.equalTo(textField)
            $0.trailing.equalTo(textField.snp.trailing).inset(10)
            $0.width.height.equalTo(40)
        }
    }
    
    //해당 UI를 MapViewController에서 불러올 때의 자리를 지정
    func setupConstraints(in superview: UIView) {
        superview.addSubview(self)
        superview.bringSubviewToFront(self) // 항상 맨위에 올라오도록
        self.snp.makeConstraints {
            $0.top.equalTo(superview).offset(70)
            $0.leading.equalTo(superview.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(superview.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(60)
        }
    }
}
