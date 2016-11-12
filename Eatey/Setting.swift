//
//  Setting.swift
//  Eatey
//
//  Created by Alan Liu on 10/19/16.
//  Copyright © 2016 Alan Liu. All rights reserved.
//

import UIKit
import QuartzCore
import Lockbox

class Setting: UIViewController {
    
    
    override func viewDidLoad() {
        paymentView.layer.cornerRadius = 10.0;
        paymentView.layer.masksToBounds = true;
        helpView.layer.cornerRadius = 10.0;
        helpView.layer.masksToBounds = true;
        aboutView.layer.cornerRadius = 10.0;
        aboutView.layer.masksToBounds = true;
        notificationView.layer.cornerRadius = 10.0;
        notificationView.layer.masksToBounds = true;
        logoutView.layer.cornerRadius = 10.0;
        logoutView.layer.masksToBounds = true;
        
    }
    

    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var helpView: UIView!
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var logoutView: UIView!
    
    @IBAction func LogoutBtn(_ sender: UIButton) {
        print("Logged Out! \(Lockbox.archiveObject(nil, forKey: "Token")))")
    }
    
    
}
