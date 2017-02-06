//
//  SignInVC.swift
//  DevstagramPro
//
//  Created by Harry Ng on 04/02/2017.
//  Copyright © 2017 Harry Ng. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // disable signup button
        signInBtn.isEnabled = false
        signInBtn.setTitleColor(UIColor.lightText, for: .normal)
        
        signInBtn.layer.cornerRadius = 5
        
        
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
        
        handleTextField()
        
        
        
    }
    
    func handleTextField() {
        emailTxt.addTarget(self, action: #selector(SignInVC.textFieldDidChange), for: .editingChanged)
        passwordTxt.addTarget(self, action: #selector(SignInVC.textFieldDidChange), for: .editingChanged)
        
    }
    
    
    func textFieldDidChange() {
        if !((emailTxt.text?.isEmpty)!) && !((passwordTxt.text?.isEmpty)!) {
            signInBtn.setTitleColor(UIColor.white, for: .normal)
            signInBtn.isEnabled = true
        }
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        
        view.endEditing(true)
        SVProgressHUD.show()
        FIRAuth.auth()?.signIn(withEmail: emailTxt.text!, password: passwordTxt.text!, completion: { (user, error) in
            if error != nil {
                print(error!.localizedDescription)
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
                
            } else {
                SVProgressHUD.showSuccess(withStatus: "Logged In!")
                self.performSegue(withIdentifier: "NaviSegue", sender: nil)
                
            }
            
        })
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        // auto sign in current user
        if ((FIRAuth.auth()?.currentUser) != nil) {
            self.performSegue(withIdentifier: "NaviSegue", sender: nil)
            
        }
    }
    
}

