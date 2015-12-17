//
//  CreateController.swift
//  trice
//
//  Created by Corentin FARDEAU on 15/12/2015.
//  Copyright © 2015 Corentin FARDEAU. All rights reserved.
//

import UIKit
import Parse

class CreateController: UIViewController, UITextViewDelegate, UIPickerViewDataSource,UIPickerViewDelegate {

    @IBOutlet weak var titleLengthLabel: UILabel!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    
    var categories: [PFObject]!
    var pickerCategories: [[String]] = [["Category"]]
    var selectedCategory: PFObject!
    
    private var maxTitleLength = 35
    private var kbHeight: CGFloat!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        postTextView.delegate = self
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        setUI()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector : Selector("keyboardWasShown:"), name:UIKeyboardWillShowNotification, object : nil)
        
        Api.sharedInstance.getCategories(
            { categories in
                
                self.categories = categories
                self.pickerCategories = [categories.map({ (cat: PFObject) -> String in
                    return cat["name"] as! String
                })]
                
                self.categoryPicker.reloadAllComponents()
            },
            errorCallback:  { error in
                
            }
        )
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        linkTextField.resignFirstResponder()
        postTextView.resignFirstResponder()
    }
    
    
    // MARK: - Picker
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return pickerCategories.count
    }
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerCategories[component].count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerCategories[component][row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
        let categoryName = pickerCategories[component][row]
        
        if let found = categories.map({ $0["name"] as! String }).indexOf(categoryName) {
            selectedCategory = categories[found]
        }
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
        linkTextField.borderStyle = UITextBorderStyle.None
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRectMake(0.0, linkTextField.frame.size.height - 1, linkTextField.frame.size.width, 1.0);
        bottomBorder.backgroundColor = UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.0).CGColor
        linkTextField.layer.addSublayer(bottomBorder)
        
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
