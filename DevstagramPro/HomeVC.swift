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
import SDWebImage

class HomeVC: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var posts = [Post]()
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 527
        tableView.rowHeight = UITableViewAutomaticDimension
        
        loadPosts()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    
    
    func loadPosts() {
        activityIndicator.startAnimating()
        FIRDatabase.database().reference().child("posts").observe(.childAdded) { (snapshot: FIRDataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let newPost = Post.transformPostPhoto(dict: dict)
                self.fetchUser(uid: newPost.uid!, completed: {
                    self.posts.append(newPost)
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                })
                
            }
        }
    }
    
    func fetchUser (uid : String, completed: @escaping () -> Void) {
        
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformUser(dict: dict)
                self.users.append(user)
                completed()
                
            }
            
        })

        
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
    
 
    @IBAction func fakeBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "CommentSegue", sender: nil)
    }
    
    
}


extension HomeVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! HomeVCCell
        let post = posts[indexPath.row]
        let user = users[indexPath.row]
        
        // put value to the observer at HomeVCCell to run the function (alt)
        cell.post = post
        cell.user = user
        
        //cell.textLabel?.text = posts[indexPath.row].caption
        return cell
    }
    
}






