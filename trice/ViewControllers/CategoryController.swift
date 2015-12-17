//
//  CategoryController.swift
//  trice
//
//  Created by Corentin FARDEAU on 17/12/2015.
//  Copyright © 2015 Corentin FARDEAU. All rights reserved.
//

import UIKit
import Parse

class CategoryController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var categoryTableView: UITableView!
    var categories: [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categoryTableView.backgroundColor = UIColor.clearColor()
        getCategories()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getCategories(){
        
        Api.sharedInstance.getCategories(
            { categories in
                
                self.categories = categories
                self.categoryTableView.reloadData()
                
            },
            errorCallback: { error in
                
            }
        )
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let segueIdentifier = segue.identifier {
            
            switch (segueIdentifier) {
                
            case CategoryDetailsController.segueIdentifier:
                
                let categoryDetailsViewController = segue.destinationViewController as! CategoryDetailsController
                
                if let indexPath = categoryTableView.indexPathForSelectedRow {
                    
                    categoryDetailsViewController.category = categories![indexPath.row]
                    
                    categoryTableView.deselectRowAtIndexPath(indexPath, animated: true)
                }
                
                
                
                break
                
            default:
                
                break
            }
        }
        
    }
    
    // MARK: - TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let categories = self.categories {
            return categories.count
        } else {
            return 0
        }
    }
    
    func tableView(wallTableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell =  wallTableView.dequeueReusableCellWithIdentifier(CategoryTableViewCell.identifier, forIndexPath: indexPath) as! CategoryTableViewCell ;
        
        let categories = self.categories!
        
        cell.setCategory(categories[indexPath.row])
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
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
