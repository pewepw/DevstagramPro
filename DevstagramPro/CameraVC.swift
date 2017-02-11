//
//  CameraVC.swift
//  DevstagramPro
//
//  Created by Harry Ng on 05/02/2017.
//  Copyright © 2017 Harry Ng. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import SVProgressHUD

class CameraVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var photoImg: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var removeBtn: UIBarButtonItem!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        shareBtn.layer.cornerRadius = 5
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CameraVC.didTapImage))
        tapGesture.numberOfTapsRequired = 1
        photoImg.isUserInteractionEnabled = true
        photoImg.addGestureRecognizer(tapGesture)
        
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // this func should be call at viewWillAppear
        handleBadPost()
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func didTapImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let photo = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage = photo
            photoImg.image = photo
        }
        dismiss(animated: true, completion: nil)
        
        
    }
    
    
    
    
    
    @IBAction func shareBtnClicked(_ sender: Any) {
        
        SVProgressHUD.show()
        
        if let postsImg = self.selectedImage , let imageData = UIImageJPEGRepresentation(postsImg, 0.1) {
            
            let photoIDString = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("posts").child(photoIDString)
            storageRef.put(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                } else {
                    let photoURL = metadata?.downloadURL()?.absoluteString
                    
                    self.sendDatatoDatabase(photoURL: photoURL!)
                    
                }
                
                
            })
            
            
        }
        
    }
    
//    func sendDatatoDatabase (photoURL : String) {
//        let ref = FIRDatabase.database().reference()
//        let postReference = ref.child("posts")
//        let newPostID = postReference.childByAutoId().key
//        let newPostReference = postReference.child(newPostID)
//        newPostReference.setValue(["photoURL" : photoURL, "caption" : textView.text!]) { (error, reference) in
//            if error != nil {
//                SVProgressHUD.showError(withStatus: error?.localizedDescription)
//                return
//            }
//            SVProgressHUD.showSuccess(withStatus: "Post Shared")
//            self.tabBarController?.selectedIndex = 0
//            self.clean()
//            
//        }
    
    func sendDatatoDatabase (photoURL : String) {
        guard let currentUser = FIRAuth.auth()?.currentUser else {
            return
        }
        let currentUserId = currentUser.uid
        
        FIRDatabase.database().reference().child("posts").childByAutoId().setValue(["uid" : currentUserId, "photoURL" : photoURL, "caption" : textView.text!]) { (error, reference) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
                return
            }
            SVProgressHUD.showSuccess(withStatus: "Post Shared")
            self.tabBarController?.selectedIndex = 0
            self.clean()
            
        }
        
       
        
        
    }
    
    func handleBadPost() {
        if selectedImage != nil {
            shareBtn.isEnabled = true
            shareBtn.backgroundColor = UIColor.red
            
            removeBtn.isEnabled = true
            
        } else {
            shareBtn.isEnabled = false
            shareBtn.backgroundColor = UIColor.lightGray
            
            removeBtn.isEnabled = false
            
        }
    }

    
    func clean() {
        self.textView.text = ""
        self.photoImg.image = UIImage(named: "Placeholder-image")
        
        // to disable share button for the next time user tap into cameraVC
        self.selectedImage = nil
    }
    
    @IBAction func removeBtnClicked(_ sender: Any) {
        clean()
        handleBadPost()
    }
    
    
    
}
