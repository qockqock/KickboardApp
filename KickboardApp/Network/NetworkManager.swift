//
//  NetworkManager.swift
//  KickboardApp
//
//  Created by 김승희 on 7/24/24.
//

import Foundation
import Alamofire


// NetworkManager - sh
class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchData<T: Decodable>(url: URL, headers: HTTPHeaders? = nil, completion: @escaping (Result<T, AFError>) -> Void) {
        AF.request(url, headers: headers).responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
}
