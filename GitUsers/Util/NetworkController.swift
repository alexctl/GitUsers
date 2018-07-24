//
//  NetworkController.swift
//  GitUsers
//
//  Created by Alexandre Cantal on 23/07/2018.
//  Copyright © 2018 Alex. All rights reserved.
//

import Foundation
import CoreData

class NetworkController{
    
    var userDetail : [UsersData] = []
    let dataController = DataController.default
    
    /*Pour un json Array*/
    func load(_ urlString: String) {
        
        let session = URLSession.shared
        let url = URL(string: urlString)
        
        if let url = url {
            let task = session.dataTask(with: url) {
                (data, response, error) in
                
                if let data = data, let json = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [Any]{
                    
                    for user in json {
                        if let userDB = self.dataController.newObject(NSStringFromClass(Users.self)) as? Users {
                            
                            let data = user as! [String : AnyObject]
                            //check si user deja present dans la base
                            if self.dataController.userExist(id: data["id"] as! Int){
                                
                                userDB.id = Int32(data["id"] as! Int)
                                userDB.login = data["login"] as? String
                                userDB.avatar_url = data["avatar_url"] as? String
                                userDB.profil_url = data["url"] as? String
                                self.dataController.save()
                            }
                        }
                    }
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                }
            }
            task.resume()
        }
    }
    
    
    func userDetail(_ urlString: String){
        
        let session = URLSession.shared
        let url = URL(string: urlString)
        
        
        if let url = url {
            let task = session.dataTask(with: url) {
                (data, response, error) in
                
                if let data = data, let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]{
                    print(json)
                    print (json["name"])
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userDetail"), object: json, userInfo: json)
                }
            }
            
            task.resume()
        }
    }
}
