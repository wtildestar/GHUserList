//
//  User+CoreDataProperties.swift
//  GHUserList
//
//  Created by wtildestar on 05/04/2020.
//  Copyright © 2020 wtildestar. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var avatarUrl: String?
    @NSManaged public var login: String?

}
