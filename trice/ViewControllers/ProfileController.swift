//
//  ProfileController.swift
//  trice
//
//  Created by Corentin FARDEAU on 16/12/2015.
//  Copyright © 2015 Corentin FARDEAU. All rights reserved.
//

import UIKit
import Parse
import PKHUD

class ProfileController: UITableViewController {

    var user: PFUser!
    
    @IBOutlet weak var pseudoTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = Api.sharedInstance.getCurrentUser()
        pseudoTextField.text = user?.username
        mailTextField.text = user?.email
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutClickAction(sender: AnyObject) {
        Api.sharedInstance.logOut()
        self.dismissViewControllerAnimated(true, completion: nil)
    }


    @IBAction func saveClickAction(sender: AnyObject) {
        updateInformation()
        updatePassword()
    }
    
    
    func updateInformation() {
        
        let newUsername = pseudoTextField.text != user.username ? pseudoTextField.text : nil
        let newEmail = mailTextField.text != user.email ? mailTextField.text : nil
        
        if newUsername != nil || newEmail != nil {
            
            Api.sharedInstance.editcurrentUser(newUsername, email: newEmail, password: nil,
                successCallback: { user in
                    
                    PKHUD.sharedHUD.contentView = PKHUDSuccessView()
                    PKHUD.sharedHUD.show()
                    PKHUD.sharedHUD.hide(afterDelay: 1.0);
                    
                },
                errorCallback: { error in
                    
                    switch error.code {
                        
                    case 202:
                        self.showAlert("This username is unavailable.")
                        break
                        
                    case 203:
                        self.showAlert("This email address is unavailable.")
                        break
                        
                    case 100:
                        self.showAlert("Server connection error :(")
                        break
                        
                    default:
                        break
                    }
                    
                }
            )
        }
    }
    
    func updatePassword() {
        
        if !newPasswordTextField.text!.isEmpty && !passwordConfirmationTextField.text!.isEmpty && newPasswordTextField.text == passwordConfirmationTextField.text {
            
            let newPassword = newPasswordTextField.text
            
            Api.sharedInstance.editcurrentUser(nil, email: nil, password: newPassword,
                successCallback: { user in
                    
                    PKHUD.sharedHUD.contentView = PKHUDSuccessView()
                    PKHUD.sharedHUD.show()
                    PKHUD.sharedHUD.hide(afterDelay: 1.0);
                    
                },
                errorCallback: { error in
                    
                    switch error.code {
                        
                    case 202:
                        self.showAlert("This username is unavailable.")
                        break
                        
                    case 203:
                        self.showAlert("This email address is unavailable.")
                        break
                        
                    case 100:
                        self.showAlert("Server connection error :(")
                        break
                        
                    default:
                        break
                    }
                    
                }
            )
        }
        
    }
    
    // MARK: - alert
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
