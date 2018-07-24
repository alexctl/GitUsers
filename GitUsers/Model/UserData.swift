//
//  UserData.swift
//  GitUsers
//
//  Created by Alexandre Cantal on 23/07/2018.
//  Copyright © 2018 Alex. All rights reserved.
//

import Foundation

struct UsersData {
    
    var name: String
    var company: String
    var location: String
    var followers: Int
    
    init(name: String, company: String, location: String, followers: Int){
        
        self.name = name
        self.company = company
        self.location = location
        self.followers = followers
    }
    
    init(_ data: [String: Any]) {
        self.name = (data["name"] as? String) ?? ""
        self.company = (data["company"] as? String) ?? ""
        self.location = (data["location"] as? String) ?? ""
        self.followers = (data["followers"] as? Int) ?? 0
    }
}
