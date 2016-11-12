//
//  MealSelection.swift
//  Eatey
//
//  Created by Alan Liu on 10/31/16.
//  Copyright © 2016 Alan Liu. All rights reserved.
//

import UIKit
import Foundation

class MealSelection: UIViewController {
    
    let itemQuantity1 = 3
    let itemQuantity2 = 6
    let itemTagStartNum = 200
    var activeEntreeCounter = 0
    var sideActive = 0
    var entreeActiveList = [0,0,0,0,0,0]
    let entreeNameList = ["Mushroom_Chicken","Orange_Chicken","Shanghai_Angus_Beef","General_Tso_Chicken","Grilled_Teriyaki_Chicken","Kung_Pao_Chicken"]
    
    @IBAction func button201(_ sender: Any) {
        setTickFormat1(visibleItem: 1, quantity: itemQuantity1)
        sideActive = 1
        refreshOrderedItemsAndCalculatePrize ()
    }
    @IBAction func button202(_ sender: Any) {
        setTickFormat1(visibleItem: 2, quantity: itemQuantity1)
        sideActive = 2
        refreshOrderedItemsAndCalculatePrize ()
    }
    @IBAction func button203(_ sender: Any) {
        setTickFormat1(visibleItem: 3, quantity: itemQuantity1)
        sideActive = 3
        refreshOrderedItemsAndCalculatePrize ()
    }
    @IBAction func button204(_ sender: Any) {
        selectEntree(entreeSelection: 4)
        refreshOrderedItemsAndCalculatePrize ()
    }
    @IBAction func button205(_ sender: Any) {
        selectEntree(entreeSelection: 5)
        refreshOrderedItemsAndCalculatePrize ()
    }
    @IBAction func button206(_ sender: Any) {
        selectEntree(entreeSelection: 6)
        refreshOrderedItemsAndCalculatePrize ()
    }
    @IBAction func button207(_ sender: Any) {
        selectEntree(entreeSelection: 7)
        refreshOrderedItemsAndCalculatePrize ()
    }
    @IBAction func button208(_ sender: Any) {
        selectEntree(entreeSelection: 8)
        refreshOrderedItemsAndCalculatePrize ()
    }
    @IBAction func button209(_ sender: Any) {
        selectEntree(entreeSelection: 9)
        refreshOrderedItemsAndCalculatePrize ()
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTickFormat1(visibleItem: -1, quantity: itemQuantity1+itemQuantity2)
    }
    
    
    //Useless logics
    func setTickFormat1 (visibleItem: Int, quantity: Int) {
        for index in 1...quantity {
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
    
    func selectEntree (entreeSelection: Int) {
        if (entreeActiveList[entreeSelection-4] == 1)
        {
            entreeActiveList[entreeSelection-4] = 0
            self.view.viewWithTag(itemTagStartNum+entreeSelection)?.isHidden = true;
            activeEntreeCounter -= 1
        }
        else if (entreeActiveList[entreeSelection-4] == 0)
        {
            if (activeEntreeCounter == 3)
            {
                moreThanThreeEntree()
            }
            else
            {
                entreeActiveList[entreeSelection-4] = 1
                self.view.viewWithTag(itemTagStartNum+entreeSelection)?.isHidden = false;
                activeEntreeCounter += 1
            }
        }
    }
    
    func moreThanThreeEntree () {
        let alert = UIAlertController(title: "Alert", message: "Cannot select more than 3 entrees!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func refreshOrderedItemsAndCalculatePrize () {
        switch sideActive {
            case 1: newEatOrder.orderItems[0] = "Browned_Steamed_Rice"
            case 2: newEatOrder.orderItems[0] = "White_Fried_Rice"
            case 3: newEatOrder.orderItems[0] = "Chow_Mein"
            default: newEatOrder.orderItems[0] = "Null"
        }
        if activeEntreeCounter >= 1
        {
            var index2 = 1
            for index3 in 1...6
            {
                if (entreeActiveList[index3-1] == 1)
                {
                    newEatOrder.orderItems[index2]=entreeNameList[index3-1]
                    index2 += 1
                }
            }
            newEatOrder.orderItems[index2]=""
        
        }
        switch activeEntreeCounter {
            case 1: newEatOrder.priceInTotal = 5.59
            case 2: newEatOrder.priceInTotal = 6.59
            case 3: newEatOrder.priceInTotal = 8.09
            default: break
        }
    }
    
    
    
    
    
    
}
