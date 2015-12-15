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
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    var posts: [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        wallTableView.addSubview(refreshControl)
        
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
        print("refresh")
        self.wallTableView.reloadData()
        refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) ->
        [UITableViewRowAction]? {
            let addTime = UITableViewRowAction(style: .Normal, title: "+1h") {_,_ in
                
            }
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
        
        return cell
        
    }
    


}

