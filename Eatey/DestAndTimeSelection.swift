//
//  destAndTimeSelection.swift
//  Eatey
//
//  Created by Alan Liu on 10/31/16.
//  Copyright © 2016 Alan Liu. All rights reserved.
//

import UIKit

class DestAndTimeSelection: UIViewController {

    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBAction func destinationType(_ sender: Any) {
        newEatOrder.destination = destinationTextField.text!
    }
    @IBAction func timeType(_ sender: Any) {
        newEatOrder.demandingTimeInSec = Int(timeTextField.text!)!*60
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

}
