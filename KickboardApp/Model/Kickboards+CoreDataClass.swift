//
//  Kickboards+CoreDataClass.swift
//  KickboardApp
//
//  Created by 김승희 on 7/22/24.
//
//

import Foundation
import CoreData

@objc(Kickboards)
public class Kickboards: NSManagedObject {
    public static let entityName = "Kickboards"
        
    public enum Key {
        static let id = "id"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let isAvailable = "isAvailable"
        static let batteryLevel = "batteryLevel"
    }
}
