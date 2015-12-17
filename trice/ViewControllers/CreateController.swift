//
//  CreateController.swift
//  trice
//
//  Created by Corentin FARDEAU on 15/12/2015.
//  Copyright © 2015 Corentin FARDEAU. All rights reserved.
//

import UIKit
import Parse


class CreateController: UIViewController, UITextViewDelegate, CategoryDelegate {
    
    @IBOutlet weak var titleLengthLabel: UILabel!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoryButton: UIButton!
    
    private var selectedCategory: PFObject!
    private var maxTitleLength = 35
    private var kbHeight: CGFloat!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        postTextView.delegate = self
        
        setUI()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector : Selector("keyboardWasShown:"), name:UIKeyboardWillShowNotification, object : nil)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        linkTextField.resignFirstResponder()
        postTextView.resignFirstResponder()
    }
    
    func getCategory(value: PFObject) {
        
        self.categoryButton.setTitle(value["name"] as? String, forState: .Normal)
        selectedCategory = value
        
    }
    // MARK: - TextView
    
    func textViewDidBeginEditing(postTextView: UITextView) {
        if postTextView.textColor == UIColor.lightGrayColor() {
            postTextView.text = nil
            postTextView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        let nbCharactere = maxTitleLength - textView.text.characters.count
        
        if(nbCharactere < 0){
            titleLengthLabel.textColor = UIColor(red:0.76, green:0.18, blue:0.18, alpha:1.0)
        }else{
            titleLengthLabel.textColor = UIColor(red:0.77, green:0.77, blue:0.77, alpha:1.0)
        }
        
        titleLengthLabel.text = "\(nbCharactere)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWasShown(notification: NSNotification) {
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        self.bottomConstraint.constant = keyboardFrame.size.height + 20

        
        UIView.animateWithDuration(0.5) {
            self.view.layoutIfNeeded()
        }

    }
    
    // Mark: - SetUI
    
    func setUI(){
        
        //Border-bottom
        let bottomBorderLink = CALayer()
        bottomBorderLink.frame = CGRectMake(0.0, linkTextField.frame.size.height - 1, linkTextField.frame.size.width, 1.0);
        bottomBorderLink.backgroundColor = UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.0).CGColor
        linkTextField.layer.addSublayer(bottomBorderLink)
        
        let bottomBorderButton = CALayer()
        bottomBorderButton.frame = CGRectMake(0.0, linkTextField.frame.size.height - 1, linkTextField.frame.size.width, 1.0);
        bottomBorderButton.backgroundColor = UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.0).CGColor
        categoryButton.layer.addSublayer(bottomBorderButton)
        
        //Padding
        let paddingTextField = UIView(frame: CGRectMake(0, 0, 40, linkTextField.frame.height))
        linkTextField.leftView = paddingTextField
        linkTextField.leftViewMode = UITextFieldViewMode.Always
        
        postTextView.textContainerInset =
            UIEdgeInsetsMake(20,10,0,15);
        
        postTextView.textColor = UIColor.lightGrayColor()
        linkTextField.attributedPlaceholder = NSAttributedString(string:"Paste your link",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        
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
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "selectCategory"){
            let selectCategoryViewController = segue.destinationViewController as! CategoryModalController
            selectCategoryViewController.delegate = self
        }
    }
    // MARK: - Actions
    
    
    @IBAction func publishClickAction(sender: AnyObject) {
        
        if !linkTextField.text!.isEmpty && !postTextView.text!.isEmpty {
            
            if validateUrl(linkTextField.text) {
                
                if validateTitle(postTextView.text) {
                    
                    let title = postTextView.text!
                    let link = linkTextField.text!
                    
                    Api.sharedInstance.createPost(title, link: link, category: selectedCategory,
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
