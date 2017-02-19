//
//  UserAPI.swift
//  DevstagramPro
//
//  Created by Harry Ng on 13/02/2017.
//  Copyright © 2017 Harry Ng. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserAPI {
    var REF_USERS = FIRDatabase.database().reference().child("users")
    
    func observeUser(withId uid: String, completion: @escaping (User) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformUser(dict: dict)
                completion(user)
            }
        })
        
        
    }
}
