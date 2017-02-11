//
//  HomeVCCell.swift
//  DevstagramPro
//
//  Created by Harry Ng on 08/02/2017.
//  Copyright © 2017 Harry Ng. All rights reserved.
//

import UIKit
import FirebaseDatabase

class HomeVCCell: UITableViewCell {
    
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var postImgView: UIImageView!
    @IBOutlet weak var likeImg: UIImageView!
    @IBOutlet weak var commentImg: UIImageView!
    @IBOutlet weak var shareImg: UIImageView!
    @IBOutlet weak var likeCountBtn: UIButton!
    @IBOutlet weak var captionLbl: UILabel!
    
    // as a observer
    var post : Post? {
        didSet {
            updateNewsFeed()
        }
    }
    
    var videoPost: Post? {
        didSet {
            // func
        }
    }
    
    func updateNewsFeed() {
        captionLbl.text = post?.caption
        
        if let photoURLString = post?.photoURL {
            let photoURL = URL(string: photoURLString)
            postImgView.sd_setImage(with: photoURL)
        }
        setUpUserInfo()
    }
    
    func setUpUserInfo() {
        if let uid = post?.uid {
            FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
                if let dict = snapshot.value as? [String: Any] {
                    let user = User.transformUser(dict: dict)
                    self.nameLbl.text = user.username
                    if let profileImageURLString = user.profileImageURL {
                        let profileImageURL = URL(string: profileImageURLString)
                        self.avaImg.sd_setImage(with: profileImageURL)
                    }

                    
                }
                
            })
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
