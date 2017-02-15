//
//  PostAPI.swift
//  DevstagramPro
//
//  Created by Harry Ng on 13/02/2017.
//  Copyright © 2017 Harry Ng. All rights reserved.
//

import Foundation
import FirebaseDatabase

class PostAPI {
    var REF_POSTS = FIRDatabase.database().reference().child("posts")
    
    func observePosts(completion: @escaping (Post) -> Void) {
        REF_POSTS.observe(.childAdded) { (snapshot: FIRDataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let newPost = Post.transformPostPhoto(dict: dict, key: snapshot.key)
                completion(newPost)
            }
        }
    }
}
