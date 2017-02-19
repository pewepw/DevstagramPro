//
//  CommentAPI.swift
//  DevstagramPro
//
//  Created by Harry Ng on 15/02/2017.
//  Copyright © 2017 Harry Ng. All rights reserved.
//

import Foundation
import FirebaseDatabase

class CommentAPI {
    var REF_COMMENTS = FIRDatabase.database().reference().child("comments")
    
    func observeComments(withPostsID id: String, completion: @escaping (Comment) -> Void) {
        REF_COMMENTS.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let newComment = Comment.transformComment(dict: dict)
                completion(newComment)
            }
        })
}
}
