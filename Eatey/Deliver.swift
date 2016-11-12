//
//  Deliver.swift
//  Eatey
//
//  Created by Alan Liu on 10/18/16.
//  Copyright © 2016 Alan Liu. All rights reserved.
//

import UIKit
import Foundation
import MapKit
import CoreLocation
import SwiftyJSON
import Lockbox

class Deliver: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var seeAllRequestButton: UIButton!
    
    var refreshControl: UIRefreshControl!
    var location = CLLocation()
    var isTakingOrder = false
    var target:String = ""
    struct Request {
        var id: String
        var expired: Bool
        var destination: String
        var totlePrice: Float
        var selectedFood: String
        var restaurant: String
        var tips: Float
        var waitingDuration: Int
        var orderer: String
        init(json: JSON) {
            let jsonID = json["_id"].string!
            let jsonExpired = json["expired"].bool!
            let jsonDestination = json["destination"].string!
            let jsonTotalPrice = json["totalPrice"].float!
            let jsonSelectedFood = json["selectedFood"].string!
            let jsonResturant = json["restaurant"].string!
            let jsonTips = json["tips"].float!
            let jsonWaitingDuration = Int(Int(json["waitingDuration"].string!)! / 1000)
            let jsonOrderer = json["orderer"].string!
            self.id = jsonID
            self.expired = jsonExpired
            self.destination = jsonDestination
            self.totlePrice = jsonTotalPrice
            self.selectedFood = jsonSelectedFood
            self.restaurant = jsonResturant
            self.tips = jsonTips
            self.waitingDuration = jsonWaitingDuration
            self.orderer = jsonOrderer
        }
    }
    var requests = [Request]()
    
    @IBAction func closeDeliver(_ sender: Any) {
        self.view.viewWithTag(15)?.isHidden = true
        self.view.viewWithTag(20)?.isHidden = false
    }
    @IBAction func seeAllRequest(_ sender: Any) {
        self.view.viewWithTag(15)?.isHidden = false
        self.view.viewWithTag(20)?.isHidden = true
        
    }

    
    let locationManager = CLLocationManager()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControlEvents.valueChanged)
        table.addSubview(refreshControl)
        
        getRequests {
            for (index,subJson):(String, JSON) in $0 {
                //Do something you want
//                print(subJson)
                let request = Request(json: subJson)
                self.requests.append(request)
                self.table.reloadData()
            }
        }
//        print(requests)
        seeAllRequestButton.layer.cornerRadius = 10.0
        seeAllRequestButton.layer.masksToBounds = true
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        self.view.viewWithTag(15)?.isHidden = false
        self.view.viewWithTag(20)?.isHidden = true
        
    }
    

    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (requests.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CellControl
        
        cell.myImage.image = UIImage(named: ("defaultUser.png"))
        cell.myLabel.text = requests[indexPath.row].orderer
        cell.timePlaceHolder.text = requests[indexPath.row].waitingDuration.description
        cell.tipPlaceHolder.text = requests[indexPath.row].tips.description
        cell.destPlaceHolder.text = requests[indexPath.row].destination
        cell.foodPlaceHolder.text = requests[indexPath.row].totlePrice.description
        
        return (cell)
    }
    

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        takingTask(mess: requests[indexPath.row].selectedFood)
        target = requests[indexPath.row].orderer
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        
        switch status {
        case .notDetermined:
            print("NotDetermined")
        case .restricted:
            print("Restricted")
        case .denied:
            print("Denied")
        case .authorizedAlways:
            print("AuthorizedAlways")
        case .authorizedWhenInUse:
            print("AuthorizedWhenInUse")
            locationManager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("taking? \(isTakingOrder)")
        location = locations.first!
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000)
        if isTakingOrder {
            SocketIOManager.sharedInstance.emit(event: "deliverer", message: String(describing: ["location" : ["latitude": location.coordinate.latitude, "longitude": location.coordinate.longitude]]))
        }
        map.setRegion(coordinateRegion, animated: true)
//        locationManager?.stopUpdatingLocation()
//        locationManager = nil
        map.showsUserLocation = true
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to initialize GPS: ", error.localizedDescription)
    }
    
    func refresh(_ sender:AnyObject) {
        // Code to refresh table view
        var formerRequests = self.requests
        self.requests.removeAll()
        getRequests {
            if $0.count < 1 {
                self.requests = formerRequests
            }
            for (index,subJson):(String, JSON) in $0 {
                //Do something you want
                //                print(subJson)
                let request = Request(json: subJson)
                self.requests.append(request)
                self.table.reloadData()
            }
        }
        self.refreshControl.endRefreshing()
    }
    
    func takingTask(mess: String) {
        SocketIOManager.sharedInstance.establishConnection()
        let myUsername = Lockbox.unarchiveObject(forKey: "Username") as! String
        let alert = UIAlertController(title: "Confirm to deliver?", message: mess, preferredStyle: .alert)
        func okHandler(alert: UIAlertAction!) {
            // Do something...
            isTakingOrder = true
            SocketIOManager.sharedInstance.emit(event: "confirmation", message: String(describing: [myUsername, myUsername]))
            SocketIOManager.sharedInstance.emit(event: "deliverer", message: String(describing: ["location" : ["latitude": location.coordinate.latitude, "longitude": location.coordinate.longitude]]))
            self.view.viewWithTag(15)?.isHidden = true
            self.view.viewWithTag(20)?.isHidden = false
        }
        func noHandler(alert: UIAlertAction!) {
            // Do something...
            isTakingOrder = false
        }
        let action = UIAlertAction(title: "OK", style: .default, handler: okHandler)
        let action1 = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(action1)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        SocketIOManager.sharedInstance.closeConnection()
    }
 }
