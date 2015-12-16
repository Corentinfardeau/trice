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
        
        let user = PFUser()
        user.username = username
        user.password = password
        user.email = email
        user["hoursLeft"] = 3
        
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
        
        let currentUser = PFUser.currentUser()
        currentUser?.fetchInBackground()
        return currentUser
    }
    
    func userHasHoursLeft() -> Bool {
        
        if let currentUser = PFUser.currentUser() {
            
            if let hoursLeft = currentUser["hoursLeft"] as? Int {
                
                return hoursLeft != 0
                
            }
        }
        
        return false
    }
    
    
    func decreaseUserHoursLeft(successCallback: () -> (), errorCallback: (error: NSError) -> ()) {
        
        if self.userHasHoursLeft() {
            
            let currentUser = PFUser.currentUser()!
            
            if var hoursLeft = currentUser["hoursLeft"] as? Int {

                hoursLeft -= 1
                
                currentUser["hoursLeft"] = hoursLeft
                
                
                currentUser.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                    if success {
                        successCallback()
                        
                    } else {
                        errorCallback(error: error!)
                    }
                })
                
            }
            
        }
    }
    
    func editcurrentUser(username: String?, email: String?, password: String?, successCallback: (user: PFUser) -> (), errorCallback: (error: NSError) -> ()) {
        
        if let currentUser = PFUser.currentUser() {
            
            if let username = username {
                currentUser["username"] = username
            }
            
            if let email = email {
                currentUser["email"] = email
            }
            
            if let password = password {
                currentUser["password"] = password
            }
            
            currentUser.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                if success {
                    successCallback(user: currentUser)
                    
                } else {
                    errorCallback(error: error!)
                }
            })
            
        }
        
    }
    

    // MARK: - Likes
    
    func getLikes(successCallback: (likes: [PFObject]) -> (), errorCallback: (error: NSError) -> ()) {
        
        if let currentUser = PFUser.currentUser() {
            
            let relation = currentUser.relationForKey("likes")
            
            let query = relation.query()
            
            query.orderByDescending("expiresAt")
            
            query.findObjectsInBackgroundWithBlock({ (likes: [PFObject]?, error: NSError?) -> Void in
                if let likes = likes {
                    successCallback(likes: likes)
                } else {
                    errorCallback(error: error!)
                }
            })
            
        } else {
            print("Api#getLikes() Error : No user currently loggedIn")
        }
    }
    
    
    func addLike(post: PFObject, successCallback: (likes: [PFObject]) -> (), errorCallback: (error: NSError) -> ()) {

        if let currentUser = PFUser.currentUser() {
            
            let relation = currentUser.relationForKey("likes")
            relation.addObject(post)
                
            currentUser.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                if success {
                    
                    self.getLikes(
                        { likes in
                            successCallback(likes: likes)
                        },
                        errorCallback: { (error) -> () in
                            errorCallback(error: error)
                        }
                    )
                    
                } else {
                    errorCallback(error: error!)
                }
            })
    
        } else {
            print("Api#addLike() Error : No user currently loggedIn")
        }
    }
    
    
    func deleteLike(post: PFObject, successCallback: (likes: [PFObject]) -> (), errorCallback: (error: NSError) -> ()) {
        if let currentUser = PFUser.currentUser() {
            
            let relation = currentUser.relationForKey("likes")
            relation.removeObject(post)
            
            currentUser.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                if success {
                    
                    self.getLikes(
                        { likes in
                            successCallback(likes: likes)
                        },
                        errorCallback: { (error) -> () in
                            errorCallback(error: error)
                        }
                    )
                    
                } else {
                    errorCallback(error: error!)
                }
            })
            
        } else {
            print("Api#deleteLike() Error : No user currently loggedIn")
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
        
        if self.userHasHoursLeft() {
            
            self.editPost(post, title: nil, link: nil, expiresAt: newExpiresAt,
                successCallback: { post in
                    
                    self.addLike(post,
                        successCallback: { likes in
                            
                            self.decreaseUserHoursLeft(
                                {
                                    
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
                    
                },
                errorCallback: { error in
                    errorCallback(error: error)
                }
            )
            
            
        } else {
    
            errorCallback(error: NSError(domain: "Trice", code: 311, userInfo: [
                "NSLocalizedDescription": "User has no hours left"
            ]))
    
        }
    }
}





























