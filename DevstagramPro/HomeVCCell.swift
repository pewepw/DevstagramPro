//
//  HomeVCCell.swift
//  DevstagramPro
//
//  Created by Harry Ng on 08/02/2017.
//  Copyright © 2017 Harry Ng. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

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
        
        API.Post.REF_POSTS.child(post!.id!).observe(.value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let post = Post.transformPostPhoto(dict: dict, key: snapshot.key)
                self.updateLike(post: post)
            }
        })
        
        
        
        API.Post.REF_POSTS.child(post!.id!).observe(.childChanged, with: { (snapshot) in
            if let value = snapshot.value as? Int {
                self.likeCountBtn.setTitle("\(value) likes", for: .normal)
            }
        })
        
    }
    
    func updateLike(post: Post) {
        let imageName = post.likes == nil || !post.isLiked! ? "like" : "likeSelected"
        likeImg.image = UIImage(named: imageName)
        if let count = post.likesCount {
            if count != 0 {
                likeCountBtn.setTitle("\(count) likes", for: .normal)
            } else {
                likeCountBtn.setTitle("Be the first to like this", for: .normal)
            }
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
        
        let tapGestureLikeImage = UITapGestureRecognizer(target: self, action: #selector(self.didTapLikeImg))
        tapGestureLikeImage.numberOfTapsRequired = 1
        likeImg.isUserInteractionEnabled = true
        likeImg.addGestureRecognizer(tapGestureLikeImage)
    }
    
    func didTapLikeImg() {
        postRef = API.Post.REF_POSTS.child(post!.id!)
        incrementLike(forRef: postRef)
    }
    
    func incrementLike(forRef ref: FIRDatabaseReference) {
        ref.runTransactionBlock({ (currentData: FIRMutableData) -> FIRTransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = FIRAuth.auth()?.currentUser?.uid {
                print("value: \(currentData.value)")
                var likes: Dictionary<String, Bool>
                likes = post["likes"] as? [String : Bool] ?? [:]
                var likesCount = post["likesCount"] as? Int ?? 0
                if let _ = likes[uid] {
                    // Unstar the post and remove self from stars
                    likesCount -= 1
                    likes.removeValue(forKey: uid)
                } else {
                    // Star the post and add self to stars
                    likesCount += 1
                    likes[uid] = true
                }
                post["likesCount"] = likesCount as AnyObject?
                post["likes"] = likes as AnyObject?
                
                // Set value and report transaction success
                currentData.value = post
                
                return FIRTransactionResult.success(withValue: currentData)
            }
            return FIRTransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let dict = snapshot?.value as? [String: Any] {
                let post = Post.transformPostPhoto(dict: dict, key: snapshot!.key)
                self.updateLike(post: post)
            }
        }
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
