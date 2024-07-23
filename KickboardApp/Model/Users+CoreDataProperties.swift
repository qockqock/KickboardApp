//
//  Users+CoreDataProperties.swift
//  KickboardApp
//
//  Created by 김승희 on 7/22/24.
//
//

import Foundation
import CoreData


extension Users {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Users> {
        return NSFetchRequest<Users>(entityName: "Users")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var nickname: String?
    @NSManaged public var email: String?
    @NSManaged public var password: String?
    @NSManaged public var date: Date?
    @NSManaged public var image: String?
    @NSManaged public var ridedata: RideData?

}

extension Users : Identifiable {

}
