//
//  RestaurantViewController.swift
//  Eatey
//
//  Created by /Users/Proton/Documents/Xcode/Eatey/Eatey/MealSelection.swiftAlan Liu on 10/30/16.
//  Copyright © 2016 Alan Liu. All rights reserved.
//

import UIKit
import Foundation

class RestaurantSelection: UIViewController {
    
    @IBOutlet weak var tick101: UIView!
    @IBOutlet weak var tick102: UIView!
    @IBOutlet weak var tick103: UIView!
    @IBOutlet weak var tick104: UIView!
    
    let itemTagStartNum = 100
    let itemQuantity = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTickFormat(visibleItem: -1)
    }
    
    @IBAction func ChickSel(_ sender: Any) {
        newEatOrder.selectRestaurant = 1
        setTickFormat(visibleItem: newEatOrder.selectRestaurant)
        
    }
    @IBAction func subwaySel(_ sender: Any) {
        newEatOrder.selectRestaurant = 2
        setTickFormat(visibleItem: newEatOrder.selectRestaurant)
    }
    @IBAction func pandaSel(_ sender: Any) {
        newEatOrder.selectRestaurant = 3
        setTickFormat(visibleItem: newEatOrder.selectRestaurant)
    }
    @IBAction func tacoSel(_ sender: Any) {
        newEatOrder.selectRestaurant = 4
        setTickFormat(visibleItem: newEatOrder.selectRestaurant)
    }
    
    func setTickFormat (visibleItem: Int) {
        for index in 1...itemQuantity {
            if (visibleItem == -1)
            {
                self.view.viewWithTag(itemTagStartNum+index)?.isHidden = true
            }
            else if (visibleItem == index)
            {
                self.view.viewWithTag(itemTagStartNum+index)?.isHidden = false
            }
            else
            {
                self.view.viewWithTag(itemTagStartNum+index)?.isHidden = true
            }
        }
    }
    
    
    
    
}

