//
//  ProfileVC.swift
//  DevstagramPro
//
//  Created by Harry Ng on 05/02/2017.
//  Copyright © 2017 Harry Ng. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var user: User!
    var posts: [Post] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        fetchUser()
        fetchMyPosts()
        
        
    }
    
    
    func fetchUser() {
        API.User.observerCurrentUser { (user) in
            self.user = user
            self.collectionView.reloadData()
        }
    }
    
    func fetchMyPosts() {
        guard let currentUser = FIRAuth.auth()?.currentUser else {
            return
        }
        API.MyPosts.REF_MYPOSTS.child(currentUser.uid).observe(.childAdded, with: { (snapshot) in
            API.Post.observePosts(withId: snapshot.key, completion: { (post) in
                self.posts.append(post)
                self.collectionView.reloadData()
            })
        })
        
    }
}

extension ProfileVC : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ProfileVCReusable", for: indexPath) as! ProfileVCReusable
        if let user = self.user {
            headerViewCell.user = user
        }
        
        return headerViewCell
    }
    
    
}
