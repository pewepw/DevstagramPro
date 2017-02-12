//
//  Post.swift
//  DevstagramPro
//
//  Created by Harry Ng on 07/02/2017.
//  Copyright © 2017 Harry Ng. All rights reserved.
//


import Foundation
class Post {
    var caption: String?
    var photoURL: String?
    var uid: String?
    var id: String?
    
    
    static func transformPostPhoto(dict: [String: Any], key: String) -> Post {
        let post = Post()
        
        post.id = key
        post.caption = dict["caption"] as? String
        post.photoURL = dict["photoURL"] as? String
        post.uid = dict["uid"] as? String
        return post
    }
    
    static func transformPostVideo() {
        
    }
}

//extension Post {
//    static func transformPostPhoto(dict: [String: Any]) -> Post {
//        let post = Post()
//        
//        post.caption = dict["caption"] as? String
//        post.photoUrl = dict["photoUrl"] as? String
//        return post
//    }
//    
//    static func transformPostVideo() {
//        
//    }
//}


//class Post {
//    var caption : String
//    var postsImgURL : String
//
//    init(captionText : String, postsImgURLString : String) {
//        caption = captionText
//        postsImgURL = postsImgURLString
//    }
//}
