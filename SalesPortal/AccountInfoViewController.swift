
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
        addressTextView.text = "\(account.addr1)\r\n\(account.city), \(account.state) \(account.zip)"
        navigationBar.title = account.customerName
        guard account.buyer1.count > 0 else {
            disableWineBuyer123()
            return
        }
        wineBuyer1TextView.text = "\(account.buyer1)\r\n\(account.buyer1Phone)\r\n\(account.buyer1Email)"
        guard account.buyer2.count > 0 else {
            disableWineBuyer23()
            return
        }
        wineBuyer2TextView.text = "\(account.buyer2)\r\n\(account.buyer2Phone)\r\n\(account.buyer2Email)"
        guard account.buyer3.count > 0 else {
            disableWineBuyer3()
            return
        }
        wineBuyer3TextView.text = "\(account.buyer3)\r\n\(account.buyer3Phone)\r\n\(account.buyer3Email)"
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
}
