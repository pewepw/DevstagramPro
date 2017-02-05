//
//  SignUpVC.swift
//  DevstagramPro
//
//  Created by Harry Ng on 04/02/2017.
//  Copyright © 2017 Harry Ng. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    
    var selectedImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // disable signup button
        signUpBtn.isEnabled = false
        signUpBtn.setTitleColor(UIColor.lightText, for: .normal)
        
        signUpBtn.layer.cornerRadius = 5
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
        
        
        //
        usernameTxt.backgroundColor = .clear
        usernameTxt.tintColor = .white
        usernameTxt.textColor = .white
        usernameTxt.attributedPlaceholder = NSAttributedString(string: usernameTxt.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.init(white: 1, alpha: 0.7)])
        
        let bottomLayer3 = CALayer()
        bottomLayer3.frame = CGRect(x: 0, y: 29, width: 1000, height: 1)
        bottomLayer3.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        usernameTxt.layer.addSublayer(bottomLayer3)
        
        //
        emailTxt.backgroundColor = .clear
        emailTxt.tintColor = .white
        emailTxt.textColor = .white
        emailTxt.attributedPlaceholder = NSAttributedString(string: emailTxt.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.init(white: 1, alpha: 0.7)])
        
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: 29, width: 1000, height: 1)
        bottomLayer.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        emailTxt.layer.addSublayer(bottomLayer)
        
        //
        passwordTxt.backgroundColor = .clear
        passwordTxt.tintColor = .white
        passwordTxt.textColor = .white
        passwordTxt.attributedPlaceholder = NSAttributedString(string: passwordTxt.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.init(white: 1, alpha: 0.7)])
        
        let bottomLayer2 = CALayer()
        bottomLayer2.frame = CGRect(x: 0, y: 29, width: 1000, height: 1)
        bottomLayer2.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        passwordTxt.layer.addSublayer(bottomLayer2)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpVC.didTapImage))
        tapGesture.numberOfTapsRequired = 1
        avaImg.isUserInteractionEnabled = true
        avaImg.addGestureRecognizer(tapGesture)
        
        
        handleTextField()
        
        
    }
    
    func handleTextField() {
        usernameTxt.addTarget(self, action: #selector(SignUpVC.textFieldDidChange), for: .editingChanged)
        emailTxt.addTarget(self, action: #selector(SignUpVC.textFieldDidChange), for: .editingChanged)
        passwordTxt.addTarget(self, action: #selector(SignUpVC.textFieldDidChange), for: .editingChanged)
        
    }
    
    
    
    
    //    func textFieldDidChange() {
    //        guard let username = usernameTxt.text,
    //            !username.isEmpty,
    //            let email = emailTxt.text,
    //            !email.isEmpty,
    //            let password = passwordTxt.text,
    //            !password.isEmpty else {
    //
    //            signUpBtn.setTitleColor(UIColor.lightText, for: .normal)
    //            signUpBtn.isEnabled = false
    //
    //            return
    //        }
    //            signUpBtn.setTitleColor(UIColor.white, for: .normal)
    //            signUpBtn.isEnabled = true
    //
    //    }
    
    
    //    my version
    //    func textFieldDidChange() {
    //        guard !((usernameTxt.text?.isEmpty)!), !((emailTxt.text?.isEmpty)!), !((passwordTxt.text?.isEmpty)!) else {
    //
    //            return
    //        }
    //            signUpBtn.setTitleColor(UIColor.white, for: .normal)
    //            signUpBtn.isEnabled = true
    //
    //
    //    }
    
    func textFieldDidChange() {
        if !((usernameTxt.text?.isEmpty)!) && !((emailTxt.text?.isEmpty)!) && !((passwordTxt.text?.isEmpty)!) {
            signUpBtn.setTitleColor(UIColor.white, for: .normal)
            signUpBtn.isEnabled = true
        }
    }
    
    
    
    func didTapImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    
    
    @IBAction func signUpClicked(_ sender: Any) {
        FIRAuth.auth()?.createUser(withEmail: emailTxt.text!, password: passwordTxt.text!, completion: { (user : FIRUser?, error : Error?) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                
                let storageRef = FIRStorage.storage().reference().child("profile_image").child(user!.uid)
                if let profileImg = self.selectedImage , let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
                    
                    storageRef.put(imageData, metadata: nil, completion: { (metadata, error) in
                        if error != nil {
                            return
                        }
                        
                        let profileImageURL = metadata?.downloadURL()?.absoluteString
                        
                        let ref = FIRDatabase.database().reference()
                        ref.child("users").child(user!.uid).setValue(["username" : self.usernameTxt.text!, "email" : self.emailTxt.text!, "profile_image_url"  : profileImageURL])
                        
                        
                        self.performSegue(withIdentifier: "NaviSegue2", sender: nil)
                        
                    })
                    
                    
                }
                
                
                //                well, another way
                //                let ref = FIRDatabase.database().reference()
                //                let usersReference = ref.child("users")
                //                let uid = user?.uid
                //                let newUsersReference = usersReference.child(uid!)
                //                newUsersReference.setValue(["username" : self.usernameTxt.text!, "email" : self.emailTxt.text!])
                
                
            }
        })
    }
    
    
    @IBAction func dismissClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let photo = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage = photo
            avaImg.image = photo
        }
        dismiss(animated: true, completion: nil)
        
        
        
        
    }
    
    
}
