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

        let currentUser = Api.sharedInstance.getUserFromLocal()

        print(currentUser)

        if (currentUser != nil) {
            performSegueWithIdentifier("signupSegue", sender: nil)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func signupClickAction(sender: AnyObject) {

        hideError()

        if !mailTextField.text!.isEmpty && !passwordTextField.text!.isEmpty && !pseudoTextField.text!.isEmpty {

            let validEmail = mailTextField.text!.isEmail

            if validEmail {

                let email = mailTextField.text!
                let password = passwordTextField.text!
                let username = pseudoTextField.text!

                Api.sharedInstance.signUp(email, password: password, username: username,
                    successCallback: { (user) -> () in

                        Api.sharedInstance.saveUserInLocal(user)

                        self.performSegueWithIdentifier("signupSegue", sender: nil)

                    },
                    errorCallback: { (error) -> () in

                        switch error.code {

                        case 202:
                            self.showError("pseudo indisponible")
                            break

                        case 203:
                            self.showError("email indisponible.")
                            break

                        default:
                            self.showError("Erreur de connexion au server.")
                        }

                    }
                )



            } else {
                showError("Email invalide.")
            }

        } else {
            showError("Informations manquantes.")
        }



        print(pseudoTextField.text)
        print(passwordTextField.text)
        print(mailTextField.text)
        print(mailTextField.text?.isEmail)
    }


    func showError(message: String) {
        errorLabel.text = message
    }

    func hideError() {
        errorLabel.text = ""
    }

}