import UIKit
import FirebaseAuth

class SettingsViewController : UIViewController {
    
    var delegate: AppDelegate!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = UIApplication.shared.delegate as? AppDelegate
        emailLabel.text = delegate.user?.email
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "signout", sender: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
