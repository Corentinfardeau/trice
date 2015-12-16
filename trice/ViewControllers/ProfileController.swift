//
//  ProfileController.swift
//  trice
//
//  Created by Corentin FARDEAU on 16/12/2015.
//  Copyright © 2015 Corentin FARDEAU. All rights reserved.
//

import UIKit
import Parse

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
                    print("userupdated!")
                },
                errorCallback: { error in
                    self.showAlert("Server connection error :(")
                }
            )
        } else {
            print("no change")
        }
    }
    
    func updatePassword() {
        
    }
    
    // MARK: - alert
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
