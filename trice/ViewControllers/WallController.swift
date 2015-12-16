//
//  ViewController.swift
//  trice
//
//  Created by Corentin FARDEAU on 14/12/2015.
//  Copyright © 2015 Corentin FARDEAU. All rights reserved.
//

import UIKit
import Parse

class WallController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    
    @IBOutlet weak var wallTableView: UITableView!
    let gradientLayer = CAGradientLayer()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    var posts: [PFObject]?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        wallTableView.tableFooterView = UIView()
        wallTableView.addSubview(refreshControl)
        
        getPosts()

    }
    
    
    func getPosts() {
        Api.sharedInstance.getWallPosts(
            { posts in
                
                self.posts = posts
                self.wallTableView.reloadData()
                
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

    func tableView(wallTableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) ->
        [UITableViewRowAction]? {
            let addTime = UITableViewRowAction(style: .Default, title: "+1h") {_,_ in
                
                self.tableView(wallTableView, commitEditingStyle: UITableViewCellEditingStyle.None, forRowAtIndexPath: indexPath)
                
                
                let post = self.posts![indexPath.row]
                
                Api.sharedInstance.upVotePost(post,
                    successCallback: { post in
                        print("AZE")
                    },
                    errorCallback: { error in
                        switch error.code {
                        case 311:
                            print("l'utilisateur n'a plus d'heure de dispo")
                            break
                        default:
                            break
                        }
                    }
                )
            }
            
            addTime.backgroundColor = UIColor(red:0.36, green:0.88, blue:0.59, alpha:1.0)
            
            return [addTime]
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

        if let posts = self.posts {
            cell.setPost(posts[indexPath.row])
        }
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
        
    }
    


}

