//
//  Endpoint.swift
//  GHUserList
//
//  Created by wtildestar on 08/04/2020.
//  Copyright © 2020 wtildestar. All rights reserved.
//

import Foundation
import CoreData

enum Endpoint<T: NSManagedObject> {
    case users
    var url: String {
        switch self {
        case .users: return "https://api.github.com/users?since=0"
        }
    }
}
