//
//  ViewController.swift
//  trice
//
//  Created by Corentin FARDEAU on 14/12/2015.
//  Copyright © 2015 Corentin FARDEAU. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        Api.sharedInstance.getWallPosts(
            { posts in
                
                for post in posts {
                    print(post.objectId)
                    print(post["title"])
                    print(post["expiresAt"])
                }
                
            },
            errorCallback: { error in
                
            }
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

