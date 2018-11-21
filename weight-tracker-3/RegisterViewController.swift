import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func createPressed(_ sender: Any) {
        let email = emailText.text!
        let password = passwordText.text!
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            
            guard let user = authResult?.user else {
                print("user not created")
                return
            }
            print("created user: " + user.uid)
            self.populateUserCollection(user: user)
            self.performSegue(withIdentifier: "registerToTabs", sender: sender)
        }
    }
    
    func populateUserCollection(user: User) {
        let db = FirestoreDelegate.db()
        
        db.collection("users").document(user.uid).setData([
            "uid":user.uid,
            "email": user.email!
        ]){ err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added")
            }
        }
    }
}
