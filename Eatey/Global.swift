//
//  Global.swift
//  Eatey
//
//  Created by WangRex on 10/17/16.
//  Copyright © 2016 Alan Liu. All rights reserved.
//

import Foundation
import Lockbox
import AFNetworking
import SwiftyJSON

class eatOrder {
    var username: String = ""
    var selectRestaurant: Int = 0
    var orderItems: [String] = ["","","","","","","","",""]
    var tip: Float = 0.0
    var priceInTotal: Float = 0.0
    var destination: String = ""
    var demandingTimeInSec: Int = 0
}
var newEatOrder = eatOrder()

var token = NSString()
var username = NSString()

extension String {
    func isValidEmail() -> Bool {
        let regex = try? NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex?.firstMatch(in: self, options: [], range: NSMakeRange(0, self.characters.count)) != nil
    }
}

func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
    return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
}

func getUserName(completion: @escaping (_ username: String) -> Void) {
//    var username = String()
    let myToken = Lockbox.unarchiveObject(forKey: "Token")
    if myToken != nil {
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.setValue(myToken as! String, forHTTPHeaderField: "authorization")
        let url = "http://45.79.208.141:8000/api/logintest/"
        manager.post(url, parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response: Any?) in
            let responseJson = JSON(response as Any)
            for (key, subJson):(String, JSON) in responseJson {
                let username = subJson.description as String
                completion(username)
            }
        }) { (task: URLSessionDataTask?, err: Error) in
            print(err)
        }
    }
}

func getRequests(completion: @escaping (_ result: JSON) -> Void) {
    let myToken = Lockbox.unarchiveObject(forKey: "Token")
    if myToken != nil {
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.setValue(myToken as! String, forHTTPHeaderField: "authorization")
        let url = "http://45.79.208.141:8000/api/order/get"
        manager.get(url, parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response: Any?) in
            let responseJson = JSON(response as Any)
            completion(responseJson)
//            print(responseJson)
        }) { (task: URLSessionDataTask?, err: Error) in
            print(err)
        }
    }

}
