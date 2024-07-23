//
//  ReturnViewController.swift
//  KickboardApp
//
//  Created by 김승희 on 7/22/24.
//

import UIKit
import SnapKit

class ReturnViewController: UIViewController {
    
    // ReturnView에 있는 내용 갖고오기
    private let returnView = ReturnView()
    
    // 정보 받아와서 값 넣을꺼
//    private let returnInfo = ReturnInfo(usageTime: "14:31", paymentAmount: 5900, promotionDiscount: 1000, totalAmount: 4900)
    
    override func loadView() {
        view = returnView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
    }
}
