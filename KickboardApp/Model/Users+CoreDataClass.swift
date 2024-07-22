//
//  Users+CoreDataClass.swift
//  KickboardApp
//
//  Created by 김승희 on 7/22/24.
//
//

import Foundation
import CoreData

@objc(Users)
public class Users: NSManagedObject {
    public static let entityName = "Users"
        
        public enum Key {
            static let id = "id"
            static let email = "email"
            static let nickname = "nickname"
            static let password = "password"
            static let rideData = "rideData"
        }
}
