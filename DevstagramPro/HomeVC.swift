//
//  HomeVC.swift
//  DevstagramPro
//
//  Created by Harry Ng on 05/02/2017.
//  Copyright © 2017 Harry Ng. All rights reserved.
//

import UIKit
import FirebaseAuth


class HomeVC: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

      
    }

   
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
