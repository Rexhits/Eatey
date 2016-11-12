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
        
    }
    func emit(event:String, message: String) {
        self.socket.emit(event, message)
    }

}
