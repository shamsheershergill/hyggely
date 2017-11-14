//
//  launchVC.swift
//  hyggely
//
//  Created by Shamsheer on 2017-09-28.
//  Copyright © 2017 Shamsheer. All rights reserved.
//

import UIKit
import FirebaseAuth
//NSLocationWhenInUseUsageDescription this property needs to be set in info.plist
class launchVC: UIViewController {

    @IBOutlet var password: UITextField!
    @IBOutlet var email: UITextField!
    private let  HOMESEGUE = "homeSegue"
    
    override func viewDidAppear(_ animated: Bool) {
        if AuthProvider.Instance.isLoggedIn() {
            performSegue(withIdentifier: self.HOMESEGUE, sender: nil);
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        if email.text != "" && password.text != "" {
            
            AuthProvider.Instance.signUp(withEmail: email.text!, password: password.text!, loginHandler: { (message) in
                
                if message != nil {
                    self.alertTheUser(title: "Problem With Creating A New User", message: message!);
                } else {
                    
                    self.email.text = "";
                    self.password.text = "";
                    
                    self.performSegue(withIdentifier: "prefSegue2", sender: nil);
                }
                
            })
            
        } else {
            alertTheUser(title: "Email And Password Are Required", message: "Please enter email and password in the text fields");
        }
        
    }
    @IBAction func login(_ sender: Any) {
        if email.text != "" && password.text != "" {
            
            AuthProvider.Instance.login(withEmail: email.text!, password: password.text!, loginHandler: { (message) in
                
                if message != nil {
                    self.alertTheUser(title: "Problem With Authentication", message: message!);
                } else {
                    
                    self.email.text = "";
                    self.password.text = "";
                    
                    self.performSegue(withIdentifier: self.HOMESEGUE, sender: nil);
                }
                
            })
            
        } else {
            alertTheUser(title: "Email And Password Are Required", message: "Please enter email and password in the text fields");
        }

        
    }
    
    private func alertTheUser(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
    }

}
   


        

    
    

