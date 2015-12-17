//
//  ViewController.swift
//  Waltrough_Ravi
//
//  Created by Meghan on 17/12/2015.
//  Copyright © 2015 meghan regior. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var onboardingCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    var onboardingViewData: [[String:AnyObject]] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        onboardingCollectionView.dataSource = self
        onboardingCollectionView.delegate = self
        
        let onboardingData: [[String:AnyObject]] = [
            [
                "id": 1,
                "image": "illu_1",
                "text": "Share your discoveries with your friends",
                "title": "Publish your links"
            ],
            [
                "id": 2,
                "image": "illu_2",
                "text": "Give more times to ideas by swiping to the left",
                "title": "Save the best ideas"
            ],
            [
                "id": 3,
                "image": "illu_3",
                "text": "Each day, you can extend the visibility of three ideas",
                "title": "3 hours to give every day"
            ]
        ]
        
        onboardingViewData = onboardingData
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if Api.sharedInstance.getCurrentUser() == nil {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func startButton(sender: AnyObject) {
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let pageWidth = CGRectGetWidth(scrollView.frame)
        let currentPage = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        
        pageControl.currentPage = Int(currentPage)
        
    }

    
    // MARK: - CollectionView DataSource & Delegate
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingViewData.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(OnBoardingCollectionViewCell.cellIdentifier, forIndexPath: indexPath) as! OnBoardingCollectionViewCell
        let data = onboardingViewData[indexPath.row]
        cell.parseData(data)
        return cell
    }

}

