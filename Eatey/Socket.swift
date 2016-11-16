//
//  Socket.swift
//  Eatey
//
//  Created by WangRex on 11/10/16.
//  Copyright © 2016 Alan Liu. All rights reserved.
//

import Foundation
import SocketIO
import SwiftyJSON
import Lockbox

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    
    let socket = SocketIOClient(socketURL: URL(string: "http://45.79.208.141:8000")!)
    let myUsername = Lockbox.unarchiveObject(forKey: "Username")
    
    override init() {
        super.init()
        addHandler()
        establishConnection()
        
    }
    func establishConnection() {
        socket.connect()
        
        
    }
    func closeConnection() {
        socket.disconnect()
    }
    
    func addHandler() {
        self.socket.onAny {print("Got event: \($0.event), with items: \($0.items)")}
        socket.on(username as String) { data, ack in
            print(data)
        }
        socket.on("connect") {data, ack in
            if self.myUsername != nil {
                self.emit(event: "user", message: String(describing: self.myUsername!))
            }
        }
        
        self.socket.on("chat") { data, ack in
            let vc = getVisibleViewController()
//            let text = UITextField()
            
            if vc != nil {
                let alertVC = UIAlertController(title: "Got New Message!", message: String(describing: data), preferredStyle: .alert)
                alertVC.addTextField {text in
                    text.placeholder = "Enter your response here"
                }
                let action = UIAlertAction(title: "Send", style: .default, handler: { send in
                    if !(alertVC.textFields?.isEmpty)! {
                        let text = alertVC.textFields![0]
                        if text.text != nil {
                            self.emit(event: "chat", message: "\(username),\(text.text!)")
                        }

                    }
                    
                })
                let cancel = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertVC.addAction(action)
                alertVC.addAction(cancel)
                vc?.present(alertVC, animated: true, completion: nil)
            }
        }
        
        postRequestHandler()
        
    }
    func emit(event:String, message: SocketData) {
        self.socket.emit(event, message)
    }
    
    
    func postRequestHandler() {
        self.socket.on("Order Taken") { data, ack in
            print("Order Taken By: \(data[0])")
            self.emit(event: "confirmations", message: "\(data[0] as! String),\(username)")
        }
        
        self.socket.on("deliverergo") { data, ack in
//            print("deliverergo: \(data)")
            let response = JSON(data as Any)
            for (key, subJson) in response {
                let y = Double(subJson["longitude"].doubleValue)
                let x = Double(subJson["latitude"].doubleValue)
                delivererlocation = [x,y]
            }

        }
    }


}
