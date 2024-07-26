//
//  DataGenerator.swift
//  KickboardApp
//
//  Created by 김승희 on 7/23/24.
//

import Foundation


// 킥보드 위치, 배터리정보 난수생성 데이터 500개, appdelegate에서 사용 - sh
// 사용시 앱을 실행할 때마다 500개씩 생성되므로 주의 - sh
class DataGenerator {
    let coreDataManager = CoreDataManager.shared
    
    func CreateRandomData() {
        for _ in 0..<1000 {
            let randomLatitude = Double.random(in: 37.43...37.682)
            let randomLongitude = Double.random(in: 126.77...127.18)
            let randomBattery = Double.random(in: 10...99)
            let isAvailable = true
            
            let values: [String: Any] = [
                "id": UUID(),
                "latitude": randomLatitude,
                "longitude": randomLongitude,
                "isavailable": isAvailable,
                "batteryLevel": randomBattery
            ]
            
            coreDataManager.create(entityType: Kickboards.self, values: values)
        }
    }
}
