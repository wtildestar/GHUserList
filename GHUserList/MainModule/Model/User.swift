//
//  User.swift
//  GHUserList
//
//  Created by wtildestar on 28/03/2020.
//  Copyright © 2020 wtildestar. All rights reserved.
//

import Foundation

struct User: Codable {
    var postId: Int
    var id: Int
    var name: String
    var email: String
    var body: String
//    var login: String
//    var avatarUrl: String?
}
