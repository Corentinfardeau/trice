//
//  ViewController.swift
//  trice
//
//  Created by Corentin FARDEAU on 14/12/2015.
//  Copyright © 2015 Corentin FARDEAU. All rights reserved.
//

import UIKit
import Parse
import PKHUD

class WallController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    
    @IBOutlet weak var wallTableView: UITableView!
    let gradientLayer = CAGradientLayer()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    var posts: [PFObject]?
    var likes: [PFObject]?
    var visited: [PFObject]?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        wallTableView.tableFooterView = UIView()
        wallTableView.addSubview(refreshControl)
        
        getPosts()

    }
    
    override func viewDidAppear(animated: Bool) {
        getPosts()
    }
    
    
    func getPosts() {
        Api.sharedInstance.getPostsLikesAndVisited(
            { posts, likes, visited in
                
                self.posts = posts
                self.likes = likes
                self.visited = visited
                self.wallTableView.reloadData()
                self.refreshControl.endRefreshing()
                
            },
            errorCallback: { error in
                
            }
        )
    }
    

    func handleRefresh(refreshControl: UIRefreshControl) {
        getPosts()
        self.wallTableView.reloadData()
        refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table View
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 86
    }
    
    func tableView(wallTableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }

    func tableView(wallTableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
            
        if let currentUser = Api.sharedInstance.getCurrentUser() {
            
            let hasHoursLeft = currentUser["hoursLeft"] as! Int != 0
            
            let addTime = UITableViewRowAction(style: .Default, title: hasHoursLeft ? "+1h" : "Enough for today ;)") {_,_ in
                
                self.tableView(wallTableView, commitEditingStyle: UITableViewCellEditingStyle.None, forRowAtIndexPath: indexPath)
                
                let cell = wallTableView.cellForRowAtIndexPath(indexPath)!
                
                cell.userInteractionEnabled = false
                
                let post = self.posts![indexPath.row]
                
                Api.sharedInstance.upVotePost(post,
                    successCallback: { post in
                        
                        PKHUD.sharedHUD.contentView = PKHUDSuccessView()
                        PKHUD.sharedHUD.show()
                        PKHUD.sharedHUD.hide(afterDelay: 0.8);
                        
                        wallTableView.editing = false
                        cell.userInteractionEnabled = true
                        
                        self.getPosts()
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
            
            addTime.backgroundColor = UIColor(red:0.36, green:0.88, blue:0.59, alpha:1.0)
            
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
    
    func tableView(wallTableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell =  wallTableView.dequeueReusableCellWithIdentifier(PostTableViewCell.identifier, forIndexPath: indexPath) as! PostTableViewCell ;

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
        
        wallTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}

