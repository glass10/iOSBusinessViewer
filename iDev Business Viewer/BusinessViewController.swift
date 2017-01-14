//
//  BusinessViewController.swift
//  iDev Business Viewer
//
//  Created by Cameron Glass on 1/13/17.
//  Copyright © 2017 Cameron Glass. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AFNetworking

class BusinessViewController: UITableViewController {
    
    var businesses: [Business?] = []
    
    var token:String?
    
    let clientID = "-lahDjDuzKdQUiPjkdk2kA";
    
    let secret = "3XkAAwTAmM6ocL6btQXotSc2VQgkQajjKFHBZPb35s0tpvuYR142WYaS5KB7J8NU";
    
    let baseURL = "https://api.yelp.com/oauth2/token"
    
    let searchURL = "https://api.yelp.com/v3/businesses/search"
    
    let location = "West Lafayette, IN";
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        getToken()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
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
                
                for businessJSON in businesses {
                    let businessInfo = Business(json: businessJSON)
                    self.businesses.append(businessInfo)
                }
                self.tableView.reloadData()
            }
        }
    }
    



    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(businesses.count)
        return businesses.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell

        // Configure the cell...
        let row = indexPath.row
        
        guard let businessInfo = businesses[row] else {
            return cell
        }
        
        cell.nameLabel.text = businessInfo.name
        cell.ratingLabel.text = "Rating: \(businessInfo.rating)"
        cell.priceLabel.text = businessInfo.price
        cell.distanceLabel.text = "\(businessInfo.distance)"
        cell.addressLabel.text = businessInfo.location
        let imageURL = URL(string: businessInfo.imageURL)
        cell.posterView.setImageWith(imageURL!)
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let cell = sender as! BusinessCell
        
        let destination = segue.destination as! ViewController
        
        let row = tableView.indexPath(for: cell)?.row
        
        let business = businesses[row!]
        
        destination.business = business
    }

}
