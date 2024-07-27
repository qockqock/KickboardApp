//
//  AlertImageView.swift
//  KickboardApp
//
//  Created by 김승희 on 7/27/24.
//

import UIKit
import SnapKit

class AlertImageView: UIImageView {
    
    init() {
        super.init(frame: .zero)
        self.image = UIImage(named: "UseAlertImg")
        self.contentMode = .scaleAspectFit
        self.isHidden = true
        self.alpha = 0.0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showWithAnimation() {
        self.isHidden = false
        
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 2.5, delay: 0.5, options: [], animations: {
                self.alpha = 0.0
            }) { _ in
                self.isHidden = true
            }
        }
    }
}
