//
//  MyPostsAPI.swift
//  DevstagramPro
//
//  Created by Harry Ng on 20/02/2017.
//  Copyright © 2017 Harry Ng. All rights reserved.
//

import Foundation
import FirebaseDatabase

class MyPostsAPI {
    var REF_MYPOSTS = FIRDatabase.database().reference().child("myPosts")
    
    
}
