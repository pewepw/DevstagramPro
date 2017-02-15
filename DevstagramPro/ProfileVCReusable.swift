//
//  ProfileVCReusable.swift
//  DevstagramPro
//
//  Created by Harry Ng on 15/02/2017.
//  Copyright © 2017 Harry Ng. All rights reserved.
//

import UIKit

class ProfileVCReusable: UICollectionReusableView {
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postsCountLabel: UIStackView!
    @IBOutlet weak var followersCountLabel: UIStackView!
    @IBOutlet weak var followingsCountLabel: UIStackView!
    
    
    func updateView() {
        API.User.REF_CURRENT_USER?.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformUser(dict: dict)
                self.nameLabel.text = user.username
                
                if let photoURLString = user.profileImageURL {
                    let photoURL = URL(string: photoURLString)
                    self.avaImg.sd_setImage(with: photoURL)
                }
            }
        })
        
    }
}

