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

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    
    let socket = SocketIOClient(socketURL: URL(string: "http://45.79.208.141:8000")!)
    
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
        postRequestHandler()
        
    }
    func emit(event:String, message: SocketData) {
        self.socket.emit(event, message)
    }
    
    
    func postRequestHandler() {
        self.socket.on("Order Taken") { data, ack in
            print("Order Taken: \(data)")
        }
        self.socket.on("deliverergo") { data, ack in
            print("deliverergo: \(data)")
            let response = JSON(data as Any)
            for i in response {
                print("JSON: \(i)")
            }
//            let location = response.characters.split{$0 == ","}.map(String.init)
//            delivererlocation.append(Double(location[0])!)
//            delivererlocation.append(Double(location[1])!)
        }
    }


}
