//
//  AccountInfoViewController.swift
//  SalesPortal
//
//  Created by administrator on 11/7/16.
//  Copyright © 2016 Polaner Selections. All rights reserved.
//

import UIKit

class AccountInfoViewController: UIViewController {
    
    weak var account: Account?

    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var wineBuyer1Label: UILabel!
    @IBOutlet weak var wineBuyer2Label: UILabel!
    @IBOutlet weak var wineBuyer3Label: UILabel!
    @IBOutlet weak var wineBuyer1TextView: UITextView!
    @IBOutlet weak var wineBuyer2TextView: UITextView!
    @IBOutlet weak var wineBuyer3TextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let account = account else {
            return
        }
        //let address2 = account.addr2.characters.count > 0 ? "\(account.addr2)\r\n" : ""
        //addressTextView.text = "\(account.addr1)\r\n\(address2)\(account.city), \(account.state) \(account.zip)"
        addressTextView.text = "\(account.addr1)\r\n\(account.city), \(account.state) \(account.zip)"
        navigationBar.title = account.customerName
        guard account.buyer1.characters.count > 0 else {
            disableWineBuyer123()
            return
        }
        wineBuyer1TextView.text = "\(account.buyer1)\r\n\(account.buyer1Phone)\r\n\(account.buyer1Email)"
        guard account.buyer2.characters.count > 0 else {
            disableWineBuyer23()
            return
        }
        wineBuyer2TextView.text = "\(account.buyer2)\r\n\(account.buyer2Phone)\r\n\(account.buyer2Email)"
        guard account.buyer3.characters.count > 0 else {
            disableWineBuyer3()
            return
        }
        wineBuyer3TextView.text = "\(account.buyer3)\r\n\(account.buyer3Phone)\r\n\(account.buyer3Email)"
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismiss(_ sender: AnyObject) {
        self.dismiss(animated: false, completion: nil)
    }

    func disableWineBuyer123() {
        wineBuyer1Label.text = ""
        wineBuyer2Label.text = ""
        wineBuyer3Label.text = ""
    }
    
    func disableWineBuyer23() {
        wineBuyer2Label.text = ""
        wineBuyer3Label.text = ""
    }
    
    func disableWineBuyer3() {
        wineBuyer3Label.text = ""
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
