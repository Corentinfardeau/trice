//
//  Api.swift
//  trice
//
//  Created by Gabriel Vergnaud on 14/12/2015.
//  Copyright © 2015 Corentin FARDEAU. All rights reserved.
//

import Parse

class Api {
    
    static var sharedInstance = Api()
    
    
    // MARK: - User account
    
    func signUp(email: String, password: String, username: String, successCallback: (user: PFUser) -> (), errorCallback: (error: NSError) -> ()) {
        
        self.logOut()
        
        let user = PFUser()
        user.username = username
        user.password = password
        user.email = email
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if succeeded {
                successCallback(user: user)
            } else {
                errorCallback(error: error!)
            }
            
        }
    }
    
    
    func loginIn(username: String, password: String, successCallback: (user: PFUser) -> (), errorCallback: (error: NSError) -> ()) {
        
        self.logOut()
        
        PFUser.logInWithUsernameInBackground(username, password: password) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                successCallback(user: user!)
            } else {
                errorCallback(error: error!)
            }
        }

    }
    
    
    
    func logOut() {
        if PFUser.currentUser() != nil {
            PFUser.logOut()
        }
    }
    
    func getCurrentUser() -> PFUser? {
        return PFUser.currentUser()
    }
    

    // MARK: - Likes
    
    func getLikes(successCallback: (likes: [PFObject]) -> (), errorCallback: (error: NSError) -> ()) {
        
        if let currentUser = PFUser.currentUser() {
            currentUser.fetchInBackgroundWithBlock { (user: PFObject?, error: NSError?) -> Void in
                if let user = user {
                    
                    if let likes = user["likes"] as? [AnyObject] {
                        
                        var newLikes = [PFObject]()
                        
                        for like in likes {
                            print(like)
                            // le parsing ne marche pas ici. checker si je fais bien comme il faut avec mon array de pointers
                            newLikes.append(like as! PFObject)
                        }
                        
                        
                        successCallback(likes: newLikes)
                        
                    } else {
                        print("Api#getLikes() Coundnt get likes array for user \(user)")
                    }

                } else {
                    errorCallback(error: error!)
                }
            }
        }
        
    }
    
    
    func addLike(post: PFObject, successCallback: (likes: [PFObject]) -> (), errorCallback: (error: NSError) -> ()) {

        if let currentUser = PFUser.currentUser() {
            
            if var likes = currentUser["likes"]! as? [PFObject] {
        
                likes  += [post]
                
                currentUser["likes"] = likes
                
                currentUser.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                    if success {
                        successCallback(likes: likes)
                    } else {
                        errorCallback(error: error!)
                    }
                })
                
            }
    
        }
    }
    
    
    func deleteLike(post: PFObject, successCallback: (likes: [PFObject]) -> (), errorCallback: (error: NSError) -> ()) {
        if let currentUser = PFUser.currentUser() {
            
            if var likes = currentUser["likes"]! as? [PFObject] {
                
                likes = likes.filter({ (like) -> Bool in
                    return like.objectId != post.objectId
                })
                
                currentUser["likes"] = likes
                
                currentUser.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                    if success {
                        successCallback(likes: likes)
                    } else {
                        errorCallback(error: error!)
                    }
                })
                
            }
            
        }
    }
    
    
    // MARK: - Post
    
    private func addHoursToDate(date: NSDate, hours: Double) -> NSDate {
        let initialTimestamp = date.timeIntervalSince1970 as Double
        let timestamp = initialTimestamp + hours * 3600
        return NSDate(timeIntervalSince1970: timestamp)
    }
    
    func createPost(title: String, link: String, successCallback: (post: PFObject) -> (), errorCallback: (error: NSError) -> ()) {

        if let currentUser = PFUser.currentUser() {
        
            let post = PFObject(className: "Post")
            
            post["author"] = currentUser
            post["title"] = title
            post["link"] = link
            post["expiresAt"] = self.addHoursToDate(NSDate(), hours: 12)
            
            post.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                if (success) {
                    successCallback(post: post)
                } else {
                    errorCallback(error: error!)
                }
            }
            
        } else {
            print("CreatePost failed, user wasnt logged In")
        }
        
    }
    
    
    func editPost(post: PFObject, title: String?, link: String?, expiresAt: NSDate?, successCallback: (post: PFObject) -> (), errorCallback: (error: NSError) -> ()) {
        if let title = title {
            post["title"] = title
        }
        
        if let link = link {
            post["link"] = link
        }
        
        if let expiresAt = expiresAt {
            post["expiresAt"] = expiresAt
        }
        
        post.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                successCallback(post: post)
            } else {
                errorCallback(error: error!)
            }
        }
    }
    
    
    func deletePost(post: PFObject, successCallback: () -> (), errorCallback: (error: NSError) -> ()) {
        post.deleteInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                successCallback()
            } else {
                errorCallback(error: error!)
            }
        }
    }
    
    func getWallPosts(successCallback: (posts: [PFObject]) -> (), errorCallback: (error: NSError) -> ()) {
        let query = PFQuery(className: "Post")
        
        query.whereKey("expiresAt", greaterThan: NSDate())
        query.orderByDescending("expiresAt")
        
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                successCallback(posts: posts!)
            } else {
                errorCallback(error: error!)
            }
        }
    }
    
    func upVotePost(post: PFObject, successCallback: (post: PFObject) -> (), errorCallback: (error: NSError) -> ()) {
        
        let newExpiresAt = self.addHoursToDate(post["expiresAt"] as! NSDate, hours: 1)
        
        self.editPost(post, title: nil, link: nil, expiresAt: newExpiresAt,
            successCallback: { post in
                
                self.addLike(post,
                    successCallback: { likes in
                        successCallback(post: post)
                    },
                    errorCallback: { error in
                        errorCallback(error: error)
                    }
                )
                
            },
            errorCallback: { error in
                errorCallback(error: error)
            }
        )
    }
}





























