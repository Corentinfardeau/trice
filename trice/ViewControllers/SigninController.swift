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

    @IBOutlet weak var pseudoTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var formView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        passwordTextField.delegate = self
        pseudoTextField.delegate = self
        pseudoTextField.addTarget(self, action: "pseudoTextFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        passwordTextField.addTarget(self, action: "passwordTextFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector : Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object : nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "tap:")
        view.addGestureRecognizer(tapGesture)

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
    
    func pseudoTextFieldDidChange(pseudoTextField: UITextField) {
        checkForm()
    }
    
    func passwordTextFieldDidChange(pseudoTextField: UITextField) {
        checkForm()
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
                    
                    self.showAlert("Oups", message: "invalid credentials")
                    
                }
            )
            
        } else {
            showAlert("Oups", message: "Missing informations.")
        }
        
    }
    
    // MARK: - UI
    
    func setUI(){
        formView.layer.cornerRadius = 3.0
        signinButton.layer.cornerRadius = 3.0
        signinButton.userInteractionEnabled = false
        signinButton.alpha = 0.5
    }
    
    func tap(gesture: UITapGestureRecognizer) {
        
        pseudoTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.view.frame.origin.y = 0
            }, completion: nil)
        
    }

    
    // MARK: - Check form
    func checkForm(){
        
        if(passwordTextField.text != "" && pseudoTextField.text != ""){
            signinButton.userInteractionEnabled = true
            signinButton.alpha = 1
        }else{
            signinButton.userInteractionEnabled = false
            signinButton.alpha = 0.5
        }

    }
    
    // MARK: - Alert
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
