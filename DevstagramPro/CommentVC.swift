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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendButton.isEnabled = false
        sendButton.layer.cornerRadius = 5
        
        handleTextField()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    @IBAction func sendBtn(_ sender: Any) {
        guard let currentUser = FIRAuth.auth()?.currentUser else {
            return
        }
        let currentUserId = currentUser.uid
        
        FIRDatabase.database().reference().child("comments").childByAutoId().setValue(["uid" : currentUserId, "commentText" : commentTextField.text!]) { (error, reference) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
                return
            }
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
