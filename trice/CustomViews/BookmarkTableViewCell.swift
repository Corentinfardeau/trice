//
//  BookmarkTableViewCell.swift
//  trice
//
//  Created by Gabriel Vergnaud on 15/12/2015.
//  Copyright © 2015 Corentin FARDEAU. All rights reserved.
//

import UIKit
import Parse

class BookmarkTableViewCell: UITableViewCell {
    
    static var identifier = "BookmarkCell"
    
    private var like: PFObject!
    
    @IBOutlet weak var likeTitleLabel: UILabel!
    @IBOutlet weak var likeLinkLabel: UILabel!
    @IBOutlet weak var likeAuthorLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setLike(like: PFObject) {
        self.like = like
        likeTitleLabel.text = like["title"] as? String
        likeLinkLabel.text = getBaseUrl(like["link"] as! String)
        
        like["author"].fetchIfNeededInBackgroundWithBlock { (author: PFObject?, error: NSError?) -> Void in
            
            like["category"].fetchIfNeededInBackgroundWithBlock { (category: PFObject?, error: NSError?) -> Void in
            
                var text = ""
                
                if let author = author {
                     text += "by \(author["username"]!)"
                }
                
                if let category = category {
                    text += " in \(category["name"])"
                }
                
                self.likeAuthorLabel.text = text
            }
        }

    }
    
    
    
    
    // MARK: - Helpers
    
    func getBaseUrl(url: String) -> String {
        let baseUrl = NSURL(string: url)
        return "\(baseUrl!.host!)"
    }

}
