//
//  CreateController.swift
//  trice
//
//  Created by Corentin FARDEAU on 15/12/2015.
//  Copyright © 2015 Corentin FARDEAU. All rights reserved.
//

import UIKit

class CreateController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var postTextView: UITextView!
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
