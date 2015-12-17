//
//  BookmarkController.swift
//  trice
//
//  Created by Gabriel Vergnaud on 15/12/2015.
//  Copyright © 2015 Corentin FARDEAU. All rights reserved.
//

import UIKit
import Parse
import PKHUD

class BookmarkController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var likes: [PFObject]?
    
    @IBOutlet weak var bookmarkTableView: UITableView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var backgroungTitle: UILabel!
    @IBOutlet weak var backgroundInfos: UITextView!
    @IBOutlet weak var backgroundButton: UIButton!

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        bookmarkTableView.tableFooterView = UIView()
        bookmarkTableView.addSubview(refreshControl)
        
        getLikes()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        getLikes()
        
    }
    
    func getLikes() {
        Api.sharedInstance.getLikes(
            { likes in
                
                self.likes = likes
                
                if(self.likes?.count == 0){
                    self.manageBackground(true)
                }else{
                    self.bookmarkTableView.reloadData()
                    self.manageBackground(false)
                }
                
                
            },
            errorCallback: { error in
                switch error.code {
                case 100:
                    self.showAlert("Oups", message: "No Internet connection ;(")
                    break
                default:
                    break
                }
            }
        )
    }
    
    func manageBackground(visible:Bool){
        
        if(visible){
            
            backgroundButton.hidden = false
            backgroundImage.hidden = false
            backgroundInfos.hidden = false
            backgroungTitle.hidden = false
            
        }else{
            
            backgroundButton.hidden = true
            backgroundImage.hidden = true
            backgroundInfos.hidden = true
            backgroungTitle.hidden = true
            
        }
        
    }
    
    @IBAction func seePostAction(sender: AnyObject) {
        
        tabBarController?.selectedIndex = 0
        
    }
    
    
    // MARK: - TableView DataSource
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        getLikes()
        self.bookmarkTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }

    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) ->
        [UITableViewRowAction]? {
            let addTime = UITableViewRowAction(style: .Default, title: "Delete") {_,_ in
                
                if let likes = self.likes {
                    self.showDeleteAlert(likes[indexPath.row])
                }
                
            }
            return [addTime]
    }
    
    func tableView(bookmarkTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let likes = self.likes {
            return likes.count
        }else{
            return 0
        }
        
    }
    
    func tableView(bookmarkTableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = bookmarkTableView.dequeueReusableCellWithIdentifier(BookmarkTableViewCell.identifier, forIndexPath: indexPath) as! BookmarkTableViewCell
        
        if let likes = self.likes {
            cell.setLike(likes[indexPath.row])
        }
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let likes = likes {
            
            let like = likes[indexPath.row]
            
            let url = NSURL(string: like["link"] as! String)!
            UIApplication.sharedApplication().openURL(url)
            
        }
        
        bookmarkTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Alert
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    func showDeleteAlert(post: PFObject) {
        
        let alert = UIAlertController(title: "Wait a second ...", message: "Are you sure you want to delete this link ?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: { (action: UIAlertAction) -> () in
            
            Api.sharedInstance.deleteLike(post,
                successCallback: { likes in
                    
                    self.likes = likes
                    self.bookmarkTableView.reloadData()
                    
                    PKHUD.sharedHUD.contentView = PKHUDSuccessView()
                    PKHUD.sharedHUD.show()
                    PKHUD.sharedHUD.hide(afterDelay: 0.8);
                    
                },
                errorCallback: { error in
                    
                    self.showAlert("Oups", message: "Couldn't delete this link.")
                    
                }
            )
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }



}
