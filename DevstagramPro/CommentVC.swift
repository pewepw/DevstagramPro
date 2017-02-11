//
//  CommentVC.swift
//  DevstagramPro
//
//  Created by Harry Ng on 11/02/2017.
//  Copyright © 2017 Harry Ng. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import SVProgressHUD

class CommentVC: UIViewController {
    
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let postID = "-KcflX1psj8f7xmy4ghw"
    var comments = [Comment]()
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 88
        tableView.rowHeight = UITableViewAutomaticDimension

        
        sendButton.isEnabled = false
        sendButton.layer.cornerRadius = 5
        
        
        handleTextField()
        
        loadComments()
        
    }
    
    func loadComments() {
        let postCommenetRef = FIRDatabase.database().reference().child("post-comments").child(self.postID)
        postCommenetRef.observe(.childAdded, with: { (snapshot) in
            print("testing")
            FIRDatabase.database().reference().child("comments").child(snapshot.key).observeSingleEvent(of: .value, with: { (commentSnap) in
                
                if let dict = commentSnap.value as? [String: Any] {
                    let newComment = Comment.transformComment(dict: dict)
                    self.fetchUser(uid: newComment.uid!, completed: {
                        self.comments.append(newComment)
                        self.tableView.reloadData()
                    })
                    
                }
            })
        })
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    @IBAction func sendBtn(_ sender: Any) {
        let ref = FIRDatabase.database().reference()
        let commentsReference = ref.child("comments")
        let newCommentID = commentsReference.childByAutoId().key
        let newCommentReference = commentsReference.child(newCommentID)
        guard let currentUser = FIRAuth.auth()?.currentUser else {
            return
        }
        
        let currentUserId = currentUser.uid
        
        newCommentReference.setValue(["uid" : currentUserId, "commentText" : commentTextField.text!]) { (error, reference) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
                return
            }
            
            
            FIRDatabase.database().reference().child("post-comments").child(self.postID).childByAutoId().setValue(true, withCompletionBlock: { (error, ref) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: error?.localizedDescription)
                    return
                }
                    
                
            })
            
            SVProgressHUD.showSuccess(withStatus: "Sent")
            self.empty()
            
            
        }
        
    }
    
    func empty() {
        self.commentTextField.text = ""
        self.sendButton.isEnabled = false
        self.sendButton.setTitleColor(UIColor.lightGray, for: .normal)
        self.sendButton.backgroundColor = UIColor.white
        
    }
    
    func handleTextField() {
        commentTextField.addTarget(self, action: #selector(CommentVC.textFieldDidChange), for: .editingChanged)
        
    }
    
    func textFieldDidChange() {
        if !(commentTextField.text?.isEmpty)!   {
            self.sendButton.setTitleColor(UIColor.white, for: .normal)
            self.sendButton.backgroundColor = UIColor(red: 67/255, green: 156/255, blue: 255/255, alpha: 1)
            sendButton.isEnabled = true
        } else {
            sendButton.setTitleColor(UIColor.lightGray, for: .normal)
            sendButton.backgroundColor = UIColor.white
            sendButton.isEnabled = false

            
        }
        
        
    }
        
        
}

extension CommentVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentVCCell
        let comment = comments[indexPath.row]
        let user = users[indexPath.row]
        
        // put value to the observer at CommentVCCell to run the function (alt)
        cell.comment = comment
        cell.user = user
        
        return cell
    }
    
}






