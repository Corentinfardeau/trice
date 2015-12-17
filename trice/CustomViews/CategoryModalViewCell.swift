//
//  CategoryModalViewCell.swift
//  trice
//
//  Created by Corentin FARDEAU on 17/12/2015.
//  Copyright © 2015 Corentin FARDEAU. All rights reserved.
//

import UIKit
import Parse

class CategoryModalViewCell: UITableViewCell {
    
    static var identifier = "CategoryModalCell"
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCategory(category: PFObject){
        
        categoryLabel.text = category["name"] as? String
        
    }

}
