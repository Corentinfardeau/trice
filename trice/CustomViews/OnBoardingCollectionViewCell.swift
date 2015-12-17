//
//  OnBoardingCollectionViewCell.swift
//  Waltrough_Ravi
//
//  Created by Meghan on 17/12/2015.
//  Copyright © 2015 meghan regior. All rights reserved.
//

import UIKit

class OnBoardingCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "onboardingCollectionViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var onboardingImage: UIImageView!
    @IBOutlet weak var onboardingText: UILabel!
    
    func parseData(data: AnyObject) {
        
        let image = data["image"] as? String
        let textDetail = data["text"] as! String
        let title = data["title"] as! String
        
        onboardingImage.image = UIImage(named: image!)
        onboardingText.text = textDetail
        titleLabel.text = title
        
    }
    
    
}
