//
//  UserViewController.swift
//  GitUsers
//
//  Created by Alexandre Cantal on 23/07/2018.
//  Copyright © 2018 Alex. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    
    @IBOutlet var nameLb: UILabel!
    @IBOutlet var companyLb: UILabel!
    @IBOutlet var locationLb: UILabel!
    @IBOutlet var followersLb: UILabel!
    @IBOutlet var userPict: UIImageView!
    
    @IBOutlet weak var profilBT: UIButton!
    
    @IBAction func openUrl(_ sender: Any) {
        if urlProfil! != "NC"{
        UIApplication.shared.openURL(URL(string: urlProfil!)!)
        }
    }
    
    var user : Users?
    var json : [String: AnyObject] = [:]
    var urlProfil : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilBT.isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(self.infos(_:)), name: NSNotification.Name(rawValue: "userDetail"), object: nil)
        title = user?.login
        
        let url_profil = user?.profil_url
        NetworkController().userDetail(url_profil!)
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userDetail"), object: json, userInfo: json)
        
        let session = URLSession.shared
        let urlString = user?.avatar_url
        let url = URL(string: urlString!)
        
        
        if let url = url {
            let task = session.dataTask(with: url) {
                (data, response, error) in
                if let data = data{
                    DispatchQueue.main.async {
                        self.userPict.image = UIImage(data: data)
                    }
                }
            }
            task.resume()
        }
        
    }
    
    @objc func infos(_ notification: NSNotification){
        DispatchQueue.main.async {
            self.nameLb.text = (notification.userInfo?["name"] as? String) ?? "Nom : NC"
            self.companyLb.text = "Entreprise : " + ((notification.userInfo?["company"] as? String) ?? "NC")
            self.locationLb.text = "Localisation : " + ((notification.userInfo?["location"] as? String) ?? "NC")
            self.followersLb.text = "Nombre de followers : " + String(((notification.userInfo?["followers"] as? Int) ?? 0))
            
            self.urlProfil = ((notification.userInfo?["html_url"] as? String) ?? "NC")
            if self.urlProfil != "NC"
            {
                self.profilBT.isEnabled = true
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

