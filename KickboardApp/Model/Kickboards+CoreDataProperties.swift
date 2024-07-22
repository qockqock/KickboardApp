//
//  Kickboards+CoreDataProperties.swift
//  KickboardApp
//
//  Created by 김승희 on 7/22/24.
//
//

import Foundation
import CoreData


extension Kickboards {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Kickboards> {
        return NSFetchRequest<Kickboards>(entityName: "Kickboards")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var isavailable: Bool
    @NSManaged public var batteryLevel: Double
    @NSManaged public var ridedata: RideData?

}

extension Kickboards : Identifiable {

}
