//
//  Helper.swift
//  DevstagramPro
//
//  Created by Harry Ng on 06/02/2017.
//  Copyright © 2017 Harry Ng. All rights reserved.
//

import Foundation



//@IBAction func signUpClicked(_ sender: Any) {
//    FIRAuth.auth()?.createUser(withEmail: emailTxt.text!, password: passwordTxt.text!, completion: { (user : FIRUser?, error : Error?) in
//        if error != nil {
//            print(error!.localizedDescription)
//        } else {
//            
//            let storageRef = FIRStorage.storage().reference().child("profile_image").child(user!.uid)
//            if let profileImg = self.selectedImage , let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
//                
//                storageRef.put(imageData, metadata: nil, completion: { (metadata, error) in
//                    if error != nil {
//                        return
//                    }
//                    
//                    let profileImageURL = metadata?.downloadURL()?.absoluteString
//                    
//                    let ref = FIRDatabase.database().reference()
//                    ref.child("users").child(user!.uid).setValue(["username" : self.usernameTxt.text!, "email" : self.emailTxt.text!, "profile_image_url"  : profileImageURL])
//                    
//                    
//                    self.performSegue(withIdentifier: "NaviSegue2", sender: nil)
//                    
//                })
//                
//                
//            }
//            

            //                well, another way
            //                let ref = FIRDatabase.database().reference()
            //                let usersReference = ref.child("users")
            //                let uid = user?.uid
            //                let newUsersReference = usersReference.child(uid!)
            //                newUsersReference.setValue(["username" : self.usernameTxt.text!, "email" : self.emailTxt.text!])
            
//            
//        }
//        
//        
//    })
//}
