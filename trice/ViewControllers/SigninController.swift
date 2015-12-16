//
//  SigninController.swift
//  trice
//
//  Created by Corentin FARDEAU on 15/12/2015.
//  Copyright © 2015 Corentin FARDEAU. All rights reserved.
//

import UIKit
import Parse

class SigninController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var pseudoTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var formView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formView.layer.cornerRadius = 3.0
        signinButton.layer.cornerRadius = 3.0
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector : Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object : nil)
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
    
    override func viewWillAppear(animated: Bool) {
        
        pseudoTextField.text = ""
        passwordTextField.text = ""
        
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func keyboardWillShow(notification : NSNotification){
        
        UIView.animateWithDuration(1, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.view.frame.origin.y = -100
            }, completion: nil)
        
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
