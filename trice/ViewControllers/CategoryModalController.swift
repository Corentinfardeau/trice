//
//  CategoryModalController.swift
//  trice
//
//  Created by Corentin FARDEAU on 17/12/2015.
//  Copyright © 2015 Corentin FARDEAU. All rights reserved.
//

import UIKit
import Parse

protocol CategoryDelegate : class{
    func getCategory(value: PFObject)
}

class CategoryModalController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var categorieTableView: UITableView!
    var categories: [PFObject]!
    
    weak var delegate: CategoryDelegate?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        categorieTableView.tableFooterView = UIView()
        
        Api.sharedInstance.getCategories(
            { categories in
                
                self.categories = categories
                self.categorieTableView.reloadData()
                
            },
            errorCallback:  { error in
                
            }
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let categories = self.categories {
            return categories.count
        } else {
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.dismissViewControllerAnimated(true, completion: nil)
        delegate?.getCategory(categories[indexPath.row])
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(categorieTableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell =  categorieTableView.dequeueReusableCellWithIdentifier(CategoryModalViewCell.identifier, forIndexPath: indexPath) as! CategoryModalViewCell ;
        
        let categories = self.categories!
        cell.setCategory(categories[indexPath.row])
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
        
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
