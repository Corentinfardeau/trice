//
//  SignupController.swift
//  trice
//
//  Created by Corentin FARDEAU on 15/12/2015.
//  Copyright © 2015 Corentin FARDEAU. All rights reserved.
//

import UIKit

class SignupController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var pseudoTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var formView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        mailTextField.delegate = self
        passwordTextField.delegate = self
        pseudoTextField.delegate = self
        mailTextField.addTarget(self, action: "mailTextFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
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
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    func keyboardWillShow(notification : NSNotification){
        
        UIView.animateWithDuration(1, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.view.frame.origin.y = -100
            }, completion: nil)
        
    }
    
    @IBAction func signupClickAction(sender: AnyObject) {

        if !mailTextField.text!.isEmpty && !passwordTextField.text!.isEmpty && !pseudoTextField.text!.isEmpty {

            let validEmail = mailTextField.text!.isEmail

            if validEmail {

                let email = mailTextField.text!
                let password = passwordTextField.text!
                let username = pseudoTextField.text!

                Api.sharedInstance.signUp(email, password: password, username: username,
                    successCallback: { (user) -> () in

                        self.performSegueWithIdentifier("signupSegue", sender: nil)

                    },
                    errorCallback: { (error) -> () in

                        switch error.code {

                        case 202:
                            self.showAlert("This username is unavailable.")
                            break

                        case 203:
                            self.showAlert("This email address is unavailable.")
                            break

                        default:
                            self.showAlert("Server connection error :(")
                        }

                    }
                )



            } else {
                showAlert("Invalid email address.")
            }

        } else {
            showAlert("Missing Informations.")
        }
        
    }
    
    func pseudoTextFieldDidChange(pseudoTextField: UITextField) {
        checkForm()
    }
    
    func passwordTextFieldDidChange(pseudoTextField: UITextField) {
        checkForm()
    }
    
    func mailTextFieldDidChange(pseudoTextField: UITextField) {
        checkForm()
    }
    
    // MARK: - UI
    func setUI(){
        signupButton.layer.cornerRadius = 3.0
        formView.layer.cornerRadius = 3.0
        signupButton.userInteractionEnabled = false
        signupButton.alpha = 0.5
    }
    
    func tap(gesture: UITapGestureRecognizer) {
        
        pseudoTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        mailTextField.resignFirstResponder()
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.view.frame.origin.y = 0
            }, completion: nil)
        
    }
    
    // MARK: - Check form
    func checkForm(){
        
        if(passwordTextField.text != "" && pseudoTextField.text != ""){
            signupButton.userInteractionEnabled = true
            signupButton.alpha = 1
        }else{
            signupButton.userInteractionEnabled = false
            signupButton.alpha = 0.5
        }
        
    }
    
    // MARK: - Alert
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

}
