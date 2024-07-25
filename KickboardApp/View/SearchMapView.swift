//
//  SearchMapView.swift
//  KickboardApp
//
//  Created by 김승희 on 7/24/24.
//

import UIKit
import SnapKit

// 뷰-컨트롤러간 데이터 전달 Delegate - sh
protocol SearchMapViewDelegate: AnyObject {
    func didSearchAddress(_ address: String)
}

class SearchMapView: UIView {
    
    weak var delegate: SearchMapViewDelegate?
    
    private let textField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "도로명/지번 주소로 검색해주세요."
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .custom)
        if let image = UIImage(named: "MapSearchButton") {
            button.setImage(image, for: .normal)
        }
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
    
    private func setupView() {
        addSubview(textField)
        addSubview(searchButton)
        
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        
        textField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        searchButton.snp.makeConstraints { make in
            make.centerY.equalTo(textField)
            make.trailing.equalTo(textField.snp.trailing).inset(10)
            make.width.height.equalTo(40)
        }
    }
    
    @objc private func searchButtonTapped() {
        guard let address = textField.text, !address.isEmpty else { return }
        print("search 버튼 눌림")
        delegate?.didSearchAddress(address)
    }
}
