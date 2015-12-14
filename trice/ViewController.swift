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
        
        
        Api.sharedInstance.loginIn("gafqqsdsdbriel", password: "password",
            successCallback: { me in

                Api.sharedInstance.getLikes(
                    { likes in
                        for like in likes {
                            
                            Api.sharedInstance.deleteLike(like,
                                successCallback: { likes in
                                    print("Like deleted: likes : \(likes)")
                                },
                                errorCallback: { error in
                                    print("Like delete Error : \(error)")
                                }
                            )
                            
                        }
                    },
                    errorCallback: { error in
                        print("Get Likes error : \(error)")
                    }
                )
            },
            errorCallback: { error in
                print("Mail error")
                print("\(error)")
            }
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

