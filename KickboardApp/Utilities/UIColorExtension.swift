//
//  UIColorExtension.swift
//  KickboardApp
//
//  Created by 김승희 on 7/27/24.
//

import UIKit

extension UIColor {
    static let twPurple = UIColor(red: 134/255, green: 74/255, blue: 238/255, alpha: 1)
}


// 컬러값을 헥사코드로 표현가능하게
extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0
        let a = CGFloat(1.0)
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
