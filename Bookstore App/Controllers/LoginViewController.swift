//
//  ViewController.swift
//  Bookstore App
//
//  Created by Nicklaus Khaw on 05/10/2021.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var invalidLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userIDTextField.delegate = self
        passwordTextField.delegate = self
        invalidLabel.isHidden = true
    }

    @IBAction func loginPressed(_ sender: UIButton) {
        userIDTextField.endEditing(true)
        passwordTextField.endEditing(true)
        
        if userIDTextField.text! != "SS" || passwordTextField.text! != "11111"{
            invalidLabel.isHidden = false
        } else {
            userIDTextField.text = ""
            passwordTextField.text = ""
            invalidLabel.isHidden = true
            self.performSegue(withIdentifier: "goToList", sender: self)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userIDTextField.endEditing(true)
        passwordTextField.endEditing(true)
        return true
    }
    
}

