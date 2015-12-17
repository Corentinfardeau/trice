//
//  CategoryDetailsController.swift
//  trice
//
//  Created by Gabriel Vergnaud on 17/12/2015.
//  Copyright © 2015 Corentin FARDEAU. All rights reserved.
//

import UIKit
import Parse
import PKHUD

class CategoryDetailsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    static var segueIdentifier = "categorySegue"
    
    var category: PFObject!
    
    
    var posts: [PFObject]?
    var likes: [PFObject]?
    var visited: [PFObject]?
    
    
    @IBOutlet weak var categoryTableView: UITableView!
    

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let category = category {
            self.title = category["name"] as? String
            
            categoryTableView.tableFooterView = UIView()
            categoryTableView.addSubview(refreshControl)
            
            getPosts(category)
            
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        getPosts(category)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func getPosts(category: PFObject) {
        Api.sharedInstance.getPostsByCategoryLikesAndVisited(category,
            successCallback: { posts, likes, visited in
                
                self.posts = posts
                self.likes = likes
                self.visited = visited
                self.categoryTableView.reloadData()
                self.refreshControl.endRefreshing()
                
            },
            errorCallback: { error in
                
            }
        )
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        getPosts(category)
        self.categoryTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    // MARK: - Table View
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(categoryTableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(categoryTableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        if let currentUser = Api.sharedInstance.getCurrentUser() {
            
            let hasHoursLeft = currentUser["hoursLeft"] as! Int != 0
            
            let addTime = UITableViewRowAction(style: .Default, title: hasHoursLeft ? "+1h" : "Enough for today ;)") {_,_ in
                
                self.tableView(categoryTableView, commitEditingStyle: UITableViewCellEditingStyle.None, forRowAtIndexPath: indexPath)
                
                let cell = categoryTableView.cellForRowAtIndexPath(indexPath)!
                
                cell.userInteractionEnabled = false
                
                let post = self.posts![indexPath.row]
                
                Api.sharedInstance.upVotePost(post,
                    successCallback: { post in
                        
                        PKHUD.sharedHUD.contentView = PKHUDSuccessView()
                        PKHUD.sharedHUD.show()
                        PKHUD.sharedHUD.hide(afterDelay: 0.8);
                        
                        categoryTableView.editing = false
                        cell.userInteractionEnabled = true
                        
                        self.getPosts(self.category)
                    },
                    errorCallback: { error in
                        switch error.code {
                        case 311:
                            print("l'utilisateur n'a plus d'heure de dispo")
                            break
                        default:
                            break
                        }
                        
                        cell.userInteractionEnabled = true
                    }
                )
            }
            
            addTime.backgroundColor = hasHoursLeft ? UIColor(red:0.36, green:0.88, blue:0.59, alpha:1.0) : UIColor(red:0.75, green:0.75, blue:0.75, alpha:1.0)
            
            return [addTime]
        }
        
        return nil
    }
    
    
    func tableView(wallTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let posts = self.posts {
            return posts.count
        }else{
            return 0
        }
        
    }
    
    func tableView(categoryTableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell =  categoryTableView.dequeueReusableCellWithIdentifier(CategoryPostTableViewCell.identifier, forIndexPath: indexPath) as! CategoryPostTableViewCell
        
        let posts = self.posts
        let likes = self.likes
        let visited = self.visited
        
        if posts != nil && likes != nil && visited != nil {
            cell.setPost(posts![indexPath.row], likes: likes!, visited: visited!)
        }
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let posts = posts {
            
            let post = posts[indexPath.row]
            
            
            
            let url = NSURL(string: post["link"] as! String)!
            UIApplication.sharedApplication().openURL(url)
            Api.sharedInstance.addPostToVisited(post)
            
        }
        
        categoryTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    

}
