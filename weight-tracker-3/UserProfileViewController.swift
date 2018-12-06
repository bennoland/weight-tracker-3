import UIKit
import Firebase

class UserProfileViewController: UIViewController {
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var uidLabel: UILabel!
    var uid: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(uid)
        uidLabel.text = uid
        
        let db = FirestoreDelegate.db()
        db.collection("users").document(uid).getDocument() {(document, err) in
            if let document = document, document.exists {
                self.emailLabel.text = document.data()?["email"] as? String
            }
        }
    }
}
