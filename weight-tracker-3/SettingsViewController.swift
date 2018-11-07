import UIKit
import FirebaseAuth

class SettingsViewController : UIViewController {
    
    var handle: AuthStateDidChangeListenerHandle?
    var user: User?
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            print("auth state changed in ViewController")
            self.user = user
            self.emailLabel.text = user?.email
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("unload")
        Auth.auth().removeStateDidChangeListener(handle!)
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
