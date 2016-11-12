//
//  TipsSelection.swift
//  Eatey
//
//  Created by Alan Liu on 10/31/16.
//  Copyright © 2016 Alan Liu. All rights reserved.
//

import UIKit

class TipsSelection: UIViewController {
    
    var tipPresetList = [0.5, 1.0, 1.3, 1.5]
    let itemTagStartNum = 400
    let itemQuantity = 4
    
    @IBAction func tipPreset1(_ sender: Any) {
        newEatOrder.tip = Float(tipPresetList[0])
        setTickFormat(visibleItem: 1)
        tipTextField.text = nil
    }
    @IBAction func tipPreset2(_ sender: Any) {
        newEatOrder.tip = Float(tipPresetList[1])
        setTickFormat(visibleItem: 2)
        tipTextField.text = nil
    }
    @IBAction func tipPreset3(_ sender: Any) {
        newEatOrder.tip = Float(tipPresetList[2])
        setTickFormat(visibleItem: 3)
        tipTextField.text = nil
    }
    @IBAction func tipPreset4(_ sender: Any) {
        newEatOrder.tip = Float(tipPresetList[3])
        setTickFormat(visibleItem: 4)
        tipTextField.text = nil
    }
    @IBOutlet weak var tipTextField: UITextField!
    @IBAction func tipType(_ sender: Any) {
        newEatOrder.tip = (Float(tipTextField.text!))!
        setTickFormat(visibleItem: -1)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setTickFormat(visibleItem: -1)

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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
