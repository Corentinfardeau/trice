//
//  SignupController.swift
//  trice
//
//  Created by Corentin FARDEAU on 15/12/2015.
//  Copyright © 2015 Corentin FARDEAU. All rights reserved.
//

import UIKit

class SignupController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var pseudoTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
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
    
    // MARK: - Alert
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

}
