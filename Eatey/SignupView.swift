//
//  SignupView.swift
//  Eatey
//
//  Created by Alan Liu on 10/16/16.
//  Copyright © 2016 Alan Liu. All rights reserved.
//

import UIKit
import QuartzCore
import AFNetworking
import SwiftyJSON
import Lockbox

class SignupView: UIViewController, UITextFieldDelegate   {
    

    
    override func viewDidLoad() {
        
        SignupStack.layer.cornerRadius = 10.0;
        SignupStack.layer.masksToBounds = true;
        SignupButton.layer.cornerRadius = 10.0;
        SignupButton.layer.masksToBounds = true;
        
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
        
        
    }
    
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet weak var SignupStack: UIView!
    @IBOutlet weak var SignupButton: UIView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    
    
    @IBAction func signupAct(_ sender: UIButton) {
        if firstNameTextField.text!.isEmpty || lastNameTextField.text!.isEmpty || emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            errorLabel.text = "Please fill up all the infomations"
        }
        else if passwordTextField.text != confirmPasswordTextField.text {
            errorLabel.text = "Password confirmation failed, please try again"
        }
        else if !emailTextField.text!.isValidEmail() {
            errorLabel.text = "Invalid Email Address, please try another one"
        }
        else {
            let manager = AFHTTPSessionManager()
            manager.requestSerializer.setValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            let url = "http://45.79.208.141:8000/api/register/"
            let package = ["firstname": firstNameTextField.text!, "lastname": lastNameTextField.text!, "password": passwordTextField.text!, "email": emailTextField.text!, "username": "\(firstNameTextField.text!)_\(lastNameTextField.text!)"]
            
            
            manager.post(url, parameters: package, progress: nil, success: { (task:URLSessionDataTask, response: Any?) in
                let responseJson = JSON(response as Any)
                for (key, subJson):(String, JSON) in responseJson {
                    print("Got response! \(key, subJson)")
                    if key == "token" {
                        let token = subJson.description as NSString
                        print("Token saved! \(Lockbox.archiveObject(token, forKey: "Token"))")
                    } else {
                        let username = subJson.description as NSString
                        print("username saved! \(Lockbox.archiveObject(username, forKey: "Username"))")
                        
                    }
                    
                    self.performSegue(withIdentifier: "gotoIndexFromSignup", sender: self)
                }
                //            print("Got response! \(response)")
            }) { (task: URLSessionDataTask?, err: Error) in
                print("Got Err! \(err)")
            }
        }
        
    }
    
    
    //Click return to dismiss the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
    
    //Click outside the keyboard to dismiss the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
