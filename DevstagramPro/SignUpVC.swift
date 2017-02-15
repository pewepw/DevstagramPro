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
import SVProgressHUD

class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    
    var selectedImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.setMaximumDismissTimeInterval(2)
        
        // disable signup button
        signUpBtn.isEnabled = false
        signUpBtn.setTitleColor(UIColor.lightText, for: .normal)
        
        signUpBtn.layer.cornerRadius = 5
        
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
        
        usernameTxt.backgroundColor = .clear
        usernameTxt.tintColor = .white
        usernameTxt.textColor = .white
        usernameTxt.attributedPlaceholder = NSAttributedString(string: usernameTxt.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.init(white: 1, alpha: 0.7)])
        
        let bottomLayer3 = CALayer()
        bottomLayer3.frame = CGRect(x: 0, y: 29, width: 1000, height: 1)
        bottomLayer3.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        usernameTxt.layer.addSublayer(bottomLayer3)
        
        emailTxt.backgroundColor = .clear
        emailTxt.tintColor = .white
        emailTxt.textColor = .white
        emailTxt.attributedPlaceholder = NSAttributedString(string: emailTxt.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.init(white: 1, alpha: 0.7)])
        
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: 29, width: 1000, height: 1)
        bottomLayer.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        emailTxt.layer.addSublayer(bottomLayer)
        
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
    
    func didTapImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let photo = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage = photo
            avaImg.image = photo
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    func handleTextField() {
        usernameTxt.addTarget(self, action: #selector(SignUpVC.textFieldDidChange), for: .editingChanged)
        emailTxt.addTarget(self, action: #selector(SignUpVC.textFieldDidChange), for: .editingChanged)
        passwordTxt.addTarget(self, action: #selector(SignUpVC.textFieldDidChange), for: .editingChanged)
        
    }
    
    func textFieldDidChange() {
        if !((usernameTxt.text?.isEmpty)!) && !((emailTxt.text?.isEmpty)!) && !((passwordTxt.text?.isEmpty)!) {
            signUpBtn.setTitleColor(UIColor.white, for: .normal)
            signUpBtn.isEnabled = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        view.endEditing(true)
        SVProgressHUD.show()
        
        if let profileImg = self.selectedImage , let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
            
            FIRAuth.auth()?.createUser(withEmail: emailTxt.text!, password: passwordTxt.text!, completion: { (user : FIRUser?, error : Error?) in
                if error != nil {
                    print(error!.localizedDescription)
                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                } else {
                    SVProgressHUD.showSuccess(withStatus: "Success!")
                    
                    // send image to database and extract an image URL
                    let storageRef = FIRStorage.storage().reference().child("profile_image").child(user!.uid)
                    storageRef.put(imageData, metadata: nil, completion: { (metadata, error) in
                        if error != nil {
                            print(error!.localizedDescription)
                        } else {
                            let profileImageURL = metadata?.downloadURL()?.absoluteString
                            
                            // send data to database
                            let ref = FIRDatabase.database().reference()
                            ref.child("users").child(user!.uid).setValue(["username" : self.usernameTxt.text!, "email" : self.emailTxt.text!, "profile_image_url"  : profileImageURL])
                            self.performSegue(withIdentifier: "NaviSegue2", sender: nil)
                            
                        }
                        
                        
                    })
                    
                    
                }
            })
            
        } else {
            SVProgressHUD.showError(withStatus: "Please Upload Profile Photo")
        }
        
    }
    
    @IBAction func dismissClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


//      let ref = FIRDatabase.database().reference()
//      let usersReference = ref.child("users")
//      let uid = user?.uid
//      let newUsersReference = usersReference.child(uid!)
//      newUsersReference.setValue(["username" : self.usernameTxt.text!, "email" : self.emailTxt.text!])


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




