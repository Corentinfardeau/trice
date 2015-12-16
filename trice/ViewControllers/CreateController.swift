//
//  CreateController.swift
//  trice
//
//  Created by Corentin FARDEAU on 15/12/2015.
//  Copyright © 2015 Corentin FARDEAU. All rights reserved.
//

import UIKit

class CreateController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var titleLengthLabel: UILabel!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var postTextView: UITextView!
    
    private var maxTitleLength = 35
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        postTextView.delegate = self
        setUI()
        
        
    }
    
    
    func setUI(){
        
        //Border-bottom
        linkTextField.borderStyle = UITextBorderStyle.None
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRectMake(0.0, linkTextField.frame.size.height - 1, linkTextField.frame.size.width, 1.0);
        bottomBorder.backgroundColor = UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.0).CGColor
        linkTextField.layer.addSublayer(bottomBorder)
        
        //Padding
        let paddingTextField = UIView(frame: CGRectMake(0, 0, 15, linkTextField.frame.height))
        linkTextField.leftView = paddingTextField
        linkTextField.leftViewMode = UITextFieldViewMode.Always
        
        postTextView.textContainerInset =
        UIEdgeInsetsMake(20,10,0,15);
        
        postTextView.textColor = UIColor.lightGrayColor()
        linkTextField.attributedPlaceholder = NSAttributedString(string:"Paste your link",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        
    }
    
    func textViewDidBeginEditing(postTextView: UITextView) {
        if postTextView.textColor == UIColor.lightGrayColor() {
            postTextView.text = nil
            postTextView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        titleLengthLabel.text = "\( maxTitleLength - textView.text.characters.count)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Validation
    
    func validateUrl (urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = NSURL(string: urlString) {
                // check if your application can open the NSURL instance
                return UIApplication.sharedApplication().canOpenURL(url)
            }
        }
        return false
    }
    
    
    func validateTitle (title: String) -> Bool {
        return title.characters.count <= maxTitleLength
    }
    
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Actions
    
    
    @IBAction func publishClickAction(sender: AnyObject) {
        
        if !linkTextField.text!.isEmpty && !postTextView.text!.isEmpty {
            
            if validateUrl(linkTextField.text) {
                
                if validateTitle(postTextView.text) {
                    
                    let title = postTextView.text!
                    let link = linkTextField.text!
                    
                    Api.sharedInstance.createPost(title, link: link,
                        successCallback: { post in
                            
                            self.dismissViewControllerAnimated(true, completion: nil)
                            
                        },
                        errorCallback: { error in
                            self.showAlert("There where an error")
                        }
                    )
                    
                } else {
                    showAlert("Your title is too long")
                }
                
            } else {
                showAlert("not a valid Url")
            }
            
        } else {
            showAlert("Information are missing")
        }
        
    }

    @IBAction func closeClickAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
