//
//  RideData+CoreDataClass.swift
//  KickboardApp
//
//  Created by 김승희 on 7/22/24.
//
//

import Foundation
import CoreData

@objc(RideData)
public class RideData: NSManagedObject {
    public static let entityName = "RideData"
        
    public enum Key {
        static let id = "id"
        static let date = "date"
        static let distance = "distance"
        static let fee = "fee"
        static let kickboardId = "kickboardId"
        static let userId = "userId"
    }
}
