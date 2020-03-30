//
//  GHError.swift
//  GHUserList
//
//  Created by wtildestar on 29/03/2020.
//  Copyright © 2020 wtildestar. All rights reserved.
//

import Foundation

enum GHError: String, Error {
    
    case invalidUsername    = "This username created an invalid request. Please try again."
    case unableToComplete   = "Unable to complete your request. Please check your internet connection."
    case invalidResponse    = "Invalid response from the server. Please try again."
    case invalidData        = "The data received from the server was invalid. Please try again."
    
}
