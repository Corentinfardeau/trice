//
//  ProfileController.swift
//  trice
//
//  Created by Corentin FARDEAU on 16/12/2015.
//  Copyright © 2015 Corentin FARDEAU. All rights reserved.
//

import UIKit

class ProfileController: UITableViewController {

    @IBOutlet weak var pseudoTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = Api.sharedInstance.getCurrentUser()
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

    
}
