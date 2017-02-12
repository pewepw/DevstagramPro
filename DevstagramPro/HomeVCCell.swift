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
    
    var homeVC : HomeVC?
    
    // as a observer
    var post : Post? {
        didSet {
            updateNewsFeed()
        }
    }
    
    var user:  User? {
        didSet {
            setUpUserInfo()
        }
    }
    
    func updateNewsFeed() {
        captionLbl.text = post?.caption
        
        if let photoURLString = post?.photoURL {
            let photoURL = URL(string: photoURLString)
            postImgView.sd_setImage(with: photoURL)
        }
        
    }
    
    func setUpUserInfo() {
        nameLbl.text = user?.username
        if let photoURLString = user?.profileImageURL {
            let photoURL = URL(string: photoURLString)
            avaImg.sd_setImage(with: photoURL, placeholderImage: UIImage(named: "placeholderImg"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        nameLbl.text = ""
        captionLbl.text = ""
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapCommentImg))
        tapGesture.numberOfTapsRequired = 1
        commentImg.isUserInteractionEnabled = true
        commentImg.addGestureRecognizer(tapGesture)
    }
    
    func didTapCommentImg() {
        if let id = post?.id {
            homeVC?.performSegue(withIdentifier: "CommentSegue", sender: id)

        }
            }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avaImg.image = UIImage(named: "placeholderImg")
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
   
}
