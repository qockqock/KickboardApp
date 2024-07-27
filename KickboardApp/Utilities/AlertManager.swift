//
//  AlertManager.swift
//  KickboardApp
//
//  Created by 김승희 on 7/27/24.
//

import UIKit

// alert 불러오는 메서드를 UIViewController의 extension에서 구현 - sh
extension UIViewController {
    func alertManager(title: String, message: String, confirmTitles: String, cancelTitles: String? = nil, confirmActions: ((UIAlertAction) -> Void)? = nil, cancelActions: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let cancelTitles = cancelTitles {
            let cancelAction = UIAlertAction(title: cancelTitles, style: .destructive, handler: cancelActions)
            alert.addAction(cancelAction)
        }
        let confirmAction = UIAlertAction(title: confirmTitles, style: .default, handler: confirmActions)
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
    }
}
