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
    @IBOutlet weak var constraintToBottom: NSLayoutConstraint!
    
    var postId : String!
    var comments = [Comment]()
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Comment"
        
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 88
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        sendButton.isEnabled = false
        sendButton.layer.cornerRadius = 5
        
        
        handleTextField()
        
        loadComments()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: .UIKeyboardDidHide, object: nil)
        
    }
    
    func keyboardWillShow(notification : NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        UIView.animate(withDuration: 0.2) {
            self.constraintToBottom.constant = keyboardFrame!.height
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(notification : NSNotification) {
        UIView.animate(withDuration: 0.2) {
            self.constraintToBottom.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func loadComments() {
        let postCommenetRef = FIRDatabase.database().reference().child("post-comments").child(self.postId)
        postCommenetRef.observe(.childAdded, with: { (snapshot) in
            print("\(snapshot.key)")
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
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
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
            
            
            FIRDatabase.database().reference().child("post-comments").child(self.postId).child(newCommentID).setValue(true, withCompletionBlock: { (error, ref) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: error?.localizedDescription)
                    return
                }
                
                
            })
            
            SVProgressHUD.showSuccess(withStatus: "Sent")
            self.empty()
            self.view.endEditing(true)
            
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






