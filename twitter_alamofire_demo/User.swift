//
//  User.swift
//  twitter_alamofire_demo
//
//  Created by Neil Shah on 10/10/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import Foundation

class User {
    
    var screenName: String?
    var name: String?
    
    static var current: User?
    
    init(dictionary: [String: Any]) {
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
    }
}
