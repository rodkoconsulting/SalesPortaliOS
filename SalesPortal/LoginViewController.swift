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
    
    //var isEntryController = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.stopAnimating()
    }
    
    override func viewDidAppear(animated: Bool) {
        //checkCredentials()
        userNameField.text = ""
        passwordField.text = ""
    }
    
   // func checkCredentials() {
   //     guard Credentials.getCredentials() != nil else {
   //         return
   //     }
        //performSegue()
   //     dismissViewControllerAnimated(true, completion: nil)
   // }
    
    //override func didReceiveMemoryWarning() {
    //    super.didReceiveMemoryWarning()
   // }
    
    func performSegue() {
        //if isEntryController {
    //        SwiftSpinner.show("Loading...", animated: true) {
    //            _ in
    //            dispatch_async(dispatch_get_main_queue()) {
    //                self.performSegueWithIdentifier("showMainTabBarController", sender: self)
    //            }
    //        }
    //    } else {
    //        dismissViewControllerAnimated(true, completion: nil)
    //    }
        self.performSegueWithIdentifier("unwindFromLogin", sender: self)
   }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        activityIndicator.startAnimating()
        resignFirstResponder()
        let username = userNameField.text! as String
        let password = passwordField.text! as String
        let credentials = Credentials(username: username, password: password)
        credentials.verifyCredentials() {
            (let responseDict, errorCompletion) in
            dispatch_async(dispatch_get_main_queue()) {
                self.activityIndicator.stopAnimating()
                }
                guard let userDict = responseDict else {
                    guard let errorCode = errorCompletion else {
                        self.sendAlert(ErrorCode.UnknownError)
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
    
    //@IBAction func unwindToLogin(sender: UIStoryboardSegue) {
    //    userNameField.text = ""
    //    passwordField.text = ""
    //}
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let length = textField.text!.characters.count - range.length + string.characters.count
        if length > 0 {
            submitButton.enabled = true
        } else {
            submitButton.enabled = false
        }
        return true
    }
    
    func sendAlert(error: ErrorCode) {
        let alertController = UIAlertController(title: "Error!", message: "\(error)", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in })
        alertController.addAction(ok)
        presentViewController(alertController, animated: true, completion: nil)
    }
}