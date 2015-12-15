//
//  PostTableViewCell.swift
//  trice
//
//  Created by Corentin FARDEAU on 15/12/2015.
//  Copyright © 2015 Corentin FARDEAU. All rights reserved.
//

import UIKit
import Parse

class PostTableViewCell: UITableViewCell {
    
    static let identifier = "PostCell"
    
    @IBOutlet weak var labelPostTitle: UILabel!
    @IBOutlet weak var labelPostLink: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setPost(post: PFObject) {
        labelPostTitle.text = post["title"] as? String
        labelPostLink.text = post["link"] as? String
    }

}
