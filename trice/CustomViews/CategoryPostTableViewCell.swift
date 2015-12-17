//
//  PostTableViewCell.swift
//  trice
//
//  Created by Gabriel VERGNAUD on 15/12/2015.
//  Copyright © 2015 Corentin FARDEAU. All rights reserved.
//

import UIKit
import Parse
import SwiftDate

class CategoryPostTableViewCell: UITableViewCell {
    
    static let identifier = "CategoryPostCell"
    
    @IBOutlet weak var ownPostMarkerView: UIView!
    @IBOutlet weak var labelPostTitle: UILabel!
    @IBOutlet weak var labelPostLink: UILabel!
    @IBOutlet weak var labelPostAuthor: UILabel!
    @IBOutlet weak var labelPostTimeLeft: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setPost(post: PFObject, likes: [PFObject], visited: [PFObject]) {
        
        ownPostMarkerView.hidden = true
        
        labelPostTitle.text = post["title"] as? String
        labelPostLink.text = getBaseUrl(post["link"] as! String)
        
        let expiresAt = post["expiresAt"] as! NSDate
        
        let date = expiresAt.toRelativeString(fromDate: NSDate(), abbreviated: true, maxUnits: 1)!
        
        labelPostTimeLeft.text = date
        
        post["author"].fetchIfNeededInBackgroundWithBlock { (author: PFObject?, error: NSError?) -> Void in
            
            if let author = author {
                self.labelPostAuthor.text = "by \(author["username"]!)"
                
                if author == Api.sharedInstance.getCurrentUser() {
                    self.ownPostMarkerView.hidden = false
                }
            }
            
        }
        
        if likes.contains(post) {
            self.labelPostTimeLeft.textColor = UIColor(red:0.37, green:0.88, blue:0.59, alpha:1.0)
        } else {
            self.labelPostTimeLeft.textColor = UIColor(red:0.67, green:0.67, blue:0.67, alpha:1.0)
        }
        
        
        if visited.contains(post) {
            self.labelPostTitle.textColor = UIColor(red:0.73, green:0.73, blue:0.73, alpha:1.0)
            self.labelPostLink.textColor = UIColor(red:0.73, green:0.73, blue:0.73, alpha:1.0)
        } else {
            self.labelPostTitle.textColor = UIColor(red:0, green:0, blue:0, alpha:1.0)
            self.labelPostLink.textColor = UIColor(red:0, green:0, blue:0, alpha:1.0)
        }
    }
    
    
    // MARK: - Helpers
    
    func getBaseUrl(url: String) -> String {
        let baseUrl = NSURL(string: url)
        return "\(baseUrl!.host!)"
    }
    
}
