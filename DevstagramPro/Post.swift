//
//  Post.swift
//  DevstagramPro
//
//  Created by Harry Ng on 07/02/2017.
//  Copyright © 2017 Harry Ng. All rights reserved.
//

import Foundation

class Post {
    var caption : String
    var postsImgURL : String
    
    init(captionText : String, postsImgURLString : String) {
        caption = captionText
        postsImgURL = postsImgURLString
    }
}
