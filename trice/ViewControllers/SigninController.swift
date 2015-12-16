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
    @IBOutlet weak var formView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formView.layer.cornerRadius = 3.0
        signinButton.layer.cornerRadius = 3.0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    

    @IBAction func signinClickAction(sender: AnyObject) {
        
        if !passwordTextField.text!.isEmpty && !pseudoTextField.text!.isEmpty {
           
            let password = passwordTextField.text!
            let username = pseudoTextField.text!
            
            Api.sharedInstance.loginIn(username, password: password,
                
                successCallback: { user in
                    
                    Api.sharedInstance.saveUserInLocal(user)
                
                    self.performSegueWithIdentifier("signinSegue", sender: nil)
                
                },
                errorCallback: { error in
                    
                    self.showError("Logins invalides")
                    
                }
            )
            
            
        } else {
            showError("Informations manquantes.")
        }
        
    }
    
    
    func showError(message: String) {
        errorLabel.text = message
    }
    
    func hideError() {
        errorLabel.text = ""
    }
    
}
