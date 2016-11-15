//
//  ConfirmSelection.swift
//  Eatey
//
//  Created by Alan Liu on 10/31/16.
//  Copyright © 2016 Alan Liu. All rights reserved.
//

import UIKit
import AFNetworking
import SwiftyJSON
import Lockbox

class ConfirmSelection: UIViewController {

    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var finalOrder: UILabel!
    var itemQuantity = 0
    var superViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EatViewController")
    
    @IBAction func confirmEatOrder(_ sender: Any) {
    //Code for sending order to Server Added here!
        let myToken = Lockbox.unarchiveObject(forKey: "Token")
        let myUsername = Lockbox.unarchiveObject(forKey: "Username")
        let manager = AFHTTPSessionManager()
        manager.requestSerializer.setValue(myToken as! String, forHTTPHeaderField: "authorization")
        let url = "http://45.79.208.141:8000/api/order/request/"
        let package = ["selectedRestaurantId": newEatOrder.selectRestaurant, "selectedFood": Array(newEatOrder.orderItems[0...itemQuantity]), "destination": newEatOrder.destination, "waitingDuration": newEatOrder.demandingTimeInSec, "tips": newEatOrder.tip, "totalPrice": newEatOrder.priceInTotal + newEatOrder.tip] as [String : Any]
        
        
        manager.post(url, parameters: package, progress: nil, success: { (task:URLSessionDataTask, response: Any?) in
            let responseJson = JSON(response as Any)
            for (key, subJson):(String, JSON) in responseJson {
                print("Got response! \(key, subJson)")
                let alert = UIAlertController(title: "Success", message: "Order Submitted", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                //                self.performSegue(withIdentifier: "gotoIndexFromSignup", sender: self)
            }
            //            print("Got response! \(response)")
        }) { (task: URLSessionDataTask?, err: Error) in
            print("Got Err! \(err)")
        }
        print(newEatOrder)
        SocketIOManager.sharedInstance.emit(event: "foodRequest", message: myUsername as! String)
        SocketIOManager.sharedInstance.postRequestHandler()
        let controller = superViewController as! Eat
        controller.view.viewWithTag(5)?.isHidden = true
        controller.view.viewWithTag(10)?.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmButton.layer.cornerRadius = 10.0;
        confirmButton.layer.masksToBounds = true;
        
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ConfirmSelection.displayOrder), userInfo: nil, repeats: true)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    func displayOrder () {
        var index = 0;
        while true
        {
            if newEatOrder.orderItems[index] != ""
            {
                index += 1
            }
            else
            {
                break
            }
        }
        index -= 1
        itemQuantity = index
        var orderItems: String = ""
        
        switch index
        {
        case 1: orderItems = newEatOrder.orderItems[0] + "\n" + newEatOrder.orderItems[1]
        case 2: orderItems = newEatOrder.orderItems[0] + "\n" + newEatOrder.orderItems[1] + "\n" + newEatOrder.orderItems[2]
        case 3: orderItems = newEatOrder.orderItems[0] + "\n" + newEatOrder.orderItems[1] + "\n" + newEatOrder.orderItems[2] + "\n" + newEatOrder.orderItems[3]
        default: break
        }
        
        finalOrder.text = "You ordered:" + "\n" + orderItems + "\n" + "\n" + "Destination:" + newEatOrder.destination + "\n" + "Time:" + String(newEatOrder.demandingTimeInSec/60) + "min" + "\n" + "\n" + "Your tip:" + String(newEatOrder.tip) + "\n" + "Food price:" + String(newEatOrder.priceInTotal) + "\n" + "***********************" + "\n" + "Total price" + String(newEatOrder.priceInTotal+newEatOrder.tip)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
