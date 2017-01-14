//
//  ViewController.swift
//  iDev Business Viewer
//
//  Created by Cameron Glass on 1/11/17.
//  Copyright © 2017 Cameron Glass. All rights reserved.
//

import UIKit
import AFNetworking

class ViewController: UIViewController {
    
    @IBOutlet weak var PictureView: UIImageView!

    @IBOutlet weak var NameLabel: UILabel!
    
    @IBOutlet weak var PhoneLabel: UILabel!
    
    @IBOutlet weak var PriceLabel: UILabel!
    
    @IBOutlet weak var LocationLabel: UILabel!
    
    var business: Business?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        guard let businessInfo = business else{
            return
        }
        
        NameLabel.text = businessInfo.name
        PhoneLabel.text = businessInfo.phoneNumber
        PriceLabel.text = businessInfo.price
        LocationLabel.text = businessInfo.location
        
        let imageURL = URL(string: businessInfo.imageURL)
        
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

    override func didReceiveMemoryWarning() {
        
        
    }
}

