//
//  Endpoint.swift
//  GHUserList
//
//  Created by wtildestar on 08/04/2020.
//  Copyright © 2020 wtildestar. All rights reserved.
//

import Foundation
import CoreData

enum Endpoint: String {
    case users = "https://api.github.com/users?since=0"
    
    var responseType: NSManagedObject.Type {
        switch self {
        case .users: return User.self
        }
    }
}
