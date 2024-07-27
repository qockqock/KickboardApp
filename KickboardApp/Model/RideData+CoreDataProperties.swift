//
//  RideData+CoreDataProperties.swift
//  KickboardApp
//
//  Created by 김승희 on 7/22/24.
//
//

import Foundation
import CoreData


extension RideData {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<RideData> {
        return NSFetchRequest<RideData>(entityName: "RideData")
    }
    @NSManaged public var id: UUID?
    @NSManaged public var userId: UUID?
    @NSManaged public var kickboardId: UUID?
    @NSManaged public var distance: String?
    @NSManaged public var date: Date?
    @NSManaged public var fee: Int32
    @NSManaged public var email: String
}

extension RideData : Identifiable {

}
