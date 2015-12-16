//
//  SigninController.swift
//  trice
//
//  Created by Corentin FARDEAU on 15/12/2015.
//  Copyright © 2015 Corentin FARDEAU. All rights reserved.
//

import UIKit

class SigninController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var pseudoTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signinButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        let currentUser = Api.sharedInstance.getCurrentUser()
    
        if (currentUser != nil) {
            performSegueWithIdentifier("signinSegue", sender: nil)
        }
    }
    

    @IBAction func signinClickAction(sender: AnyObject) {
        
        if !passwordTextField.text!.isEmpty && !pseudoTextField.text!.isEmpty {
           
            let password = passwordTextField.text!
            let username = pseudoTextField.text!
            
            Api.sharedInstance.loginIn(username, password: password,
                
                successCallback: { user in
                
                    self.performSegueWithIdentifier("signinSegue", sender: nil)
                
                },
                errorCallback: { error in
                    
                    self.showAlert("Logins invalides")
                    
                }
            )
            
            
        } else {
            showAlert("Informations manquantes.")
        }
        
    }
    
    // MARK: - Alert
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
