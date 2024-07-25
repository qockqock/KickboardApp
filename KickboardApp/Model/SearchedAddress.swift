//
//  SearchedAddress.swift
//  KickboardApp
//
//  Created by 김승희 on 7/25/24.
//

import Foundation

struct SearchedAddress: Codable {
    let documents: [Address]
}

struct Address: Codable {
    let addressName: String
    let addressType: String
    let longitude: String
    let latitude: String

    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case addressType = "address_type"
        case longitude = "x"
        case latitude = "y"
    }
}
