//
//  BookmarkController.swift
//  trice
//
//  Created by Gabriel Vergnaud on 15/12/2015.
//  Copyright © 2015 Corentin FARDEAU. All rights reserved.
//

import UIKit
import Parse

class BookmarkController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var likes: [PFObject]?
    
    @IBOutlet weak var bookmarkTableView: UITableView!
    
    
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
    
    
    func getLikes() {
        Api.sharedInstance.getLikes(
            { likes in
                
                print(likes)
                self.likes = likes
                self.bookmarkTableView.reloadData()
                
            },
            errorCallback: { error in
                
            }
        )
    }
    
    
    
    // MARK: - TableView DataSource
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        print("refresh")
        getLikes()
        self.bookmarkTableView.reloadData()
        refreshControl.endRefreshing()
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

}
