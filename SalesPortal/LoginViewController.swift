//
//  LoginViewController.swift
//  SalesPortal
//
//  Created by administrator on 4/11/16.
//  Copyright © 2016 Polaner Selections. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.stopAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        userNameField.text = ""
        passwordField.text = ""
    }
    
    
    func performSegue() {
        self.performSegue(withIdentifier: "unwindFromLogin", sender: self)
   }
    
    @IBAction func loginButtonPressed(_ sender: AnyObject) {
        activityIndicator.startAnimating()
        resignFirstResponder()
        let username = userNameField.text! as String
        let password = passwordField.text! as String
        let credentials = Credentials(username: username, password: password)
        credentials.verifyCredentials() {
            [unowned self](responseDict, errorCompletion) in
            DispatchQueue.main.async {
                [unowned self] in
                self.activityIndicator.stopAnimating()
                }
                guard let userDict = responseDict else {
                    guard let errorCode = errorCompletion else {
                        self.sendAlert(ErrorCode.unknownError)
                        return
                    }
                    self.sendAlert(errorCode)
                    return
                }
                credentials.saveCredentials(userDict)
                //self.dismissViewControllerAnimated(true, completion: nil)
                self.performSegue()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let length = textField.text!.count - range.length + string.count
        if length > 0 {
            submitButton.isEnabled = true
        } else {
            submitButton.isEnabled = false
        }
        return true
    }
    
    func sendAlert(_ error: ErrorCode) {
        let alertController = UIAlertController(title: "Error!", message: error.description, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in })
        alertController.addAction(ok)
        present(alertController, animated: true, completion: nil)
    }
}
