//
//  CategoryTableViewCell.swift
//  trice
//
//  Created by Corentin FARDEAU on 17/12/2015.
//  Copyright © 2015 Corentin FARDEAU. All rights reserved.
//

import UIKit
import Parse

class CategoryTableViewCell: UITableViewCell {

    static var identifier = "CategoryCell"
    
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
