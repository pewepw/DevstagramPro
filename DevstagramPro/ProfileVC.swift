//
//  ProfileVC.swift
//  DevstagramPro
//
//  Created by Harry Ng on 05/02/2017.
//  Copyright © 2017 Harry Ng. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    var user: User!

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        fetchUser()
        
    }

    func fetchUser() {
        API.User.observeCurrentUser { (user) in
            self.user = user
            self.collectionView.reloadData()
        }
    }
    
    
    
    
    
    
}


extension ProfileVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader , withReuseIdentifier: "ProfileVCReusable", for: indexPath) as! ProfileVCReusable
        if let user = self.user {
            reusableCell.user = user
        }
        
        return reusableCell
    }
    
}
