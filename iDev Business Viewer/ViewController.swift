//
//  ViewController.swift
//  iDev Business Viewer
//
//  Created by Cameron Glass on 1/11/17.
//  Copyright © 2017 Cameron Glass. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var PictureView: UIImageView!

    @IBOutlet weak var NameLabel: UILabel!
    
    @IBOutlet weak var PhoneLabel: UILabel!
    
    @IBOutlet weak var PriceLabel: UILabel!
    
    @IBOutlet weak var LocationLabel: UILabel!
    
    var token:String?
    
    let clientID = "-lahDjDuzKdQUiPjkdk2kA";
    
    let secret = "3XkAAwTAmM6ocL6btQXotSc2VQgkQajjKFHBZPb35s0tpvuYR142WYaS5KB7J8NU";
    
    let baseURL = "https://api.yelp.com/oauth2/token"
    
    let searchURL = "https://api.yelp.com/v3/businesses/search"
    
    let location = "West Lafayette, IN";
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getToken()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getToken(){
        Alamofire.request(baseURL, method: .post, parameters: ["grant_type" : "client_credentials", "client_id" : clientID, "client_secret" : secret], encoding: URLEncoding.default, headers: nil).responseJSON { response in
            
            if response.result.isSuccess {
                guard let info = response.result.value else {
                    print("Error")
                    return;
                }
                print(info);
                let json = JSON(info)
                print(json);
                
                self.token = json["access_token"].stringValue
                self.loadBusiness();
            }
        }
    }
    
    func loadBusiness(){
        Alamofire.request(searchURL, method: .get, parameters: ["location" : location], encoding: URLEncoding.default , headers: ["Authorization" : "Bearer \(token!)"]).validate().responseJSON {
            response in
            if response.result.isSuccess {
                guard let info = response.result.value else {
                    print("Error")
                    return;
                }
                print(info);
                let json = JSON(info)
                print(json);
                
                let businesses = json["businesses"].arrayValue
                
                let business = businesses[0]
                
                print(business);
                
                self.NameLabel.text = business["name"].stringValue
                
                self.PriceLabel.text = business["price"].stringValue
                
                self.PhoneLabel.text = business["phone"].stringValue
                
                let locationD = business["location"]
                
                self.LocationLabel.text = "\(locationD["address1"].stringValue), \(locationD["city"].stringValue)"
                
                let imageURL = URL(string : business["image_url"].stringValue)
                
                let imageRequest = URLRequest(url: imageURL!)
                
                let session = URLSession(configuration: .default)
                
                session.dataTask(with: imageRequest, completionHandler: { (data, response, error) in
                    guard let image = data else{
                        print(error?.localizedDescription ?? "error")
                        return
                    }
                    self.PictureView.image = UIImage(data: image)
                    
                }).resume()
            }
        }
    }


}

