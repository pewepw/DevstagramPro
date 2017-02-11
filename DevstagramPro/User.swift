//
//  User.swift
//  DevstagramPro
//
//  Created by Harry Ng on 11/02/2017.
//  Copyright © 2017 Harry Ng. All rights reserved.
//

import Foundation
class User {
    var email: String?
    var profileImageURL : String?
    var username: String?
}

extension User {
    static func transformUser(dict: [String: Any]) -> User {
        let user = User()
        user.email = dict["email"] as? String
        user.profileImageURL = dict["profile_image_url"] as? String
        user.username = dict["username"] as? String
        return user
        
    }
}
