//
//  PkmPhoneBook+CoreDataProperties.swift
//  pkmPhoneBook
//
//  Created by 박혜연 on 10/1/25.
//
//

import Foundation
import CoreData


extension PkmPhoneBook {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PkmPhoneBook> {
        return NSFetchRequest<PkmPhoneBook>(entityName: "PkmPhoneBook")
    }

    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var profileImage: Date?

}

extension PkmPhoneBook : Identifiable {

}
