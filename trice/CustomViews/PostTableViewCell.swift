//
//  PostTableViewCell.swift
//  trice
//
//  Created by Corentin FARDEAU on 15/12/2015.
//  Copyright © 2015 Corentin FARDEAU. All rights reserved.
//

import UIKit
import Parse
import SwiftDate

class PostTableViewCell: UITableViewCell {
    
    static let identifier = "PostCell"
    
    @IBOutlet weak var labelPostTitle: UILabel!
    @IBOutlet weak var labelPostLink: UILabel!
    @IBOutlet weak var labelPostAuthor: UILabel!
    @IBOutlet weak var labelPostTimeLeft: UILabel!
    @IBOutlet weak var ownPostMarkerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setPost(post: PFObject) {
        
        ownPostMarkerView.hidden = true
        
        labelPostTitle.text = post["title"] as? String
        labelPostLink.text = getBaseUrl(post["link"] as! String)
        
        let expiresAt = post["expiresAt"] as! NSDate
        
        let date = expiresAt.toRelativeString(fromDate: NSDate(), abbreviated: true, maxUnits: 1)!
        
        labelPostTimeLeft.text = date
        
        Api.sharedInstance.isPostLiked(post) { bool in
            if bool {
                self.labelPostTimeLeft.textColor = UIColor(red:0.37, green:0.88, blue:0.59, alpha:1.0)
            }
        }
        
        post["author"].fetchIfNeededInBackgroundWithBlock { (author: PFObject?, error: NSError?) -> Void in
            
            if let author = author {
                self.labelPostAuthor.text = "by \(author["username"]!)"
                
                if author == Api.sharedInstance.getCurrentUser() {
                    self.ownPostMarkerView.hidden = false
                }
            }
            
        }
        
    }
    
    
    // MARK: - Helpers
    
    func getBaseUrl(url: String) -> String {
        let baseUrl = NSURL(string: url)
        return "\(baseUrl!.host!)"
    }

}
