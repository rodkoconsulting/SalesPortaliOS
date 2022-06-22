
import UIKit

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.performSegue(withIdentifier: "showMainTabBarController", sender: self)
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        guard let alertController = viewControllerToPresent as? UIAlertController else {
            super.present(viewControllerToPresent, animated: flag, completion: completion)
            return
        }
        var presentingVC: UIViewController = self
        while let presentedVC = presentingVC.presentedViewController {
            presentingVC = presentedVC
        }
        presentingVC.present(alertController, animated: flag, completion: completion)
    }
}
