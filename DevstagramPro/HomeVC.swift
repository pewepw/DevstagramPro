//
//  HomeVC.swift
//  DevstagramPro
//
//  Created by Harry Ng on 05/02/2017.
//  Copyright © 2017 Harry Ng. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


class HomeVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        loadPosts()
        
    }

    
    
    func loadPosts() {
        FIRDatabase.database().reference().child("posts").observe(.childAdded) { (snapshot: FIRDataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let newPost = Post.transformPostPhoto(dict: dict)
                self.posts.append(newPost)
                self.tableView.reloadData()
            }
        }
    }
    
    //    func loadPosts() {
    //        FIRDatabase.database().reference().child("posts").observe(.childAdded) { (snapshot : FIRDataSnapshot) in
    //            if let dict = snapshot.value as? [String : Any] {
    //                let captionText = dict["caption"] as! String
    //                let postsImgURLString = dict["postsImgURL"] as! String
    //                let post = Post(captionText: captionText, postsImgURLString: postsImgURLString)
    //                self.posts.append(post)
    //                print(self.posts)
    //                self.tableView.reloadData()
    //            }
    //        }
    //        
    //    }

   
    @IBAction func logOutBtnClicked(_ sender: Any) {
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let error {
            print(error)
        }
        // dismiss(animated: true, completion: nil)
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInVC")
        self.present(signInVC, animated: true, completion: nil)
    }
    
    
    
}


extension HomeVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        //let cell = UITableViewCell()
        
        cell.textLabel?.text = posts[indexPath.row].caption
        return cell
    }
    
}






