//
//  ViewController.swift
//  GitUsers
//
//  Created by Alexandre Cantal on 23/07/2018.
//  Copyright © 2018 Alex. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class ViewController: UIViewController {
    
    
    @IBOutlet var usersCV: UICollectionView!
    
    @IBOutlet var reloadView: UIView!
    @IBAction func ReloadBt(_ sender: Any) {
        UIApplication.shared.keyWindow?.rootViewController = storyboard!.instantiateViewController(withIdentifier: "viewController")
    }
    let dataController = DataController.default
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = "Liste"
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        
        let tmpUsers = dataController.users()
        
        if tmpUsers.count == 0
        {
            
            let reachabilityManager = NetworkReachabilityManager()
            reachabilityManager?.listener = { status in
                
                switch status {
                    
                case .notReachable:
                    print("The network is not reachable")
                    self.reloadView.isHidden = false
                    
                case .reachable(.ethernetOrWiFi):
                    print("The network is reachable over the WiFi connection")
                    self.reloadView.isHidden = true
                    
                case .reachable(.wwan):
                    print("The network is reachable over the WWAN connection")
                    self.reloadView.isHidden = true
                    
                case .unknown:
                    self.reloadView.isHidden = false
                }
            }
            NetworkController().load("https://api.github.com/repos/apple/swift/contributors")
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func loadList(){
        DispatchQueue.main.async {
            self.usersCV.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
extension ViewController : UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let tmpUsers = dataController.users()
        
        return tmpUsers.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let tmpUsers = dataController.users()
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        cell.pseudo?.text = tmpUsers[indexPath.row].login
        
        let session = URLSession.shared
        let urlString = tmpUsers[indexPath.row].avatar_url
        let url = URL(string: urlString!)
        
        
        if let url = url {
            cell.tag = indexPath.row
            let task = session.dataTask(with: url) {
                (data, response, error) in
                
                if let data = data{
                    DispatchQueue.main.async {
                        if cell.tag == indexPath.row{
                            cell.imageView?.image = UIImage(data: data) //?? UIImage(named: "imageFail")
                            
                        }else{
                            //cell.movieImageView?.image = UIImage(named: "No-image-found")
                        }
                    }
                }
            }
            task.resume()
        }
        
        return cell
    }
}

extension ViewController : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let tmpUsers = dataController.users()
        
        let user = tmpUsers[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let userVC = storyboard.instantiateViewController(withIdentifier: "userViewController") as! UserViewController
        userVC.user = user
        
        self.navigationController?.pushViewController(userVC, animated: true)
    }
}

extension ViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  10
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
    }
}


