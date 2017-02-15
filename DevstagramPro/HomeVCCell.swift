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
    
    var postRef : FIRDatabaseReference!
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
        
//        let tapGestureLikeImage = UITapGestureRecognizer(target: self, action: #selector(self.didTapLikeImg))
//        tapGestureLikeImage.numberOfTapsRequired = 1
//        likeImg.isUserInteractionEnabled = true
//        likeImg.addGestureRecognizer(tapGestureLikeImage)
//    }
//    
//    func didTapLikeImg() {
//        postRef =
//        incrementLike(forRef: postRef)
//    }
//    
//    func incrementLike(forRef: FIRDatabaseReference) {
//        ref.runTransactionBlock({ (currentData: FIRMutableData) -> FIRTransactionResult in
//            if var post = currentData.value as? [String : AnyObject], let uid = FIRAuth.auth()?.currentUser?.uid {
//                var stars: Dictionary<String, Bool>
//                stars = post["stars"] as? [String : Bool] ?? [:]
//                var starCount = post["starCount"] as? Int ?? 0
//                if let _ = stars[uid] {
//                    // Unstar the post and remove self from stars
//                    starCount -= 1
//                    stars.removeValue(forKey: uid)
//                } else {
//                    // Star the post and add self to stars
//                    starCount += 1
//                    stars[uid] = true
//                }
//                post["starCount"] = starCount as AnyObject?
//                post["stars"] = stars as AnyObject?
//                
//                // Set value and report transaction success
//                currentData.value = post
//                
//                return FIRTransactionResult.success(withValue: currentData)
//            }
//            return FIRTransactionResult.success(withValue: currentData)
//        }) { (error, committed, snapshot) in
//            if let error = error {
//                print(error.localizedDescription)
//            }
//        }
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
