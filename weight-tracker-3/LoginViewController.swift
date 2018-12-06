import UIKit
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {
    
    var handle: AuthStateDidChangeListenerHandle?
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if(user == nil) {
                return
            }
            self.goToNextPage()
        }
    }
    
    func goToNextPage() {
        self.performSegue(withIdentifier: "loginToTabs", sender: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        if let email = emailText.text, let password = passwordText.text {
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                self.goToNextPage()
            }
        }
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
        performSegue(withIdentifier: "loginToRegister", sender: sender)
    }
}
