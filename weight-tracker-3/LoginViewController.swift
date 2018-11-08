import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    var handle: AuthStateDidChangeListenerHandle?
    var user: User?
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            print("auth state changed in LoginViewController")
            if(user == nil) {
                return
            }
            self.user = user
            print(user!.uid)
            self.goToNextPage()
        }
    }
    
    func goToNextPage() {
        self.performSegue(withIdentifier: "loginToTabs", sender: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        print("unload")
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        if let email = emailText.text, let password = passwordText.text {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                print("logged in " + (user?.user.uid)!)
                self.goToNextPage()
            }
        }
    }
    @IBAction func createAccountPressed(_ sender: Any) {
        performSegue(withIdentifier: "loginToRegister", sender: sender)
    }
}
