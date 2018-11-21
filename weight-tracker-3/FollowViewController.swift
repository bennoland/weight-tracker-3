import UIKit
import FirebaseAuth

class FollowViewController: UIViewController {
    var delegate: AppDelegate!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = UIApplication.shared.delegate as? AppDelegate
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.updateFollowees()
        self.updateFollowing()
    }
    
    
    func updateFollowees() {
        let db = FirestoreDelegate.db()
        db.collection("followers")
            .whereField("followee_uid", isEqualTo: (self.delegate.user?.uid)!)
            .whereField("is_allowed", isEqualTo: true)
            .getDocuments(completion: {
            (querySnapshot, err) in
            if let err = err {
                print("Error: \(err)")
                return
            }
            
            self.followersButton.setTitle("\(querySnapshot!.count)", for: UIControl.State.normal)
        })
    }
    
    func updateFollowing() {
        let db = FirestoreDelegate.db()
        db.collection("followers")
            .whereField("follower_uid", isEqualTo: (self.delegate.user?.uid)!)
            .whereField("is_allowed", isEqualTo: true)
            .getDocuments(completion: {
            (querySnapshot, err) in
            if let err = err {
                print("Error: \(err)")
                return
            }
            
            self.followingButton.setTitle("\(querySnapshot!.count)", for: UIControl.State.normal)
        })
    }
    
    @IBAction func requestPushed(_ sender: Any) {
        let emailToFollow = emailText.text!
        
        let db = FirestoreDelegate.db()
        
        db.collection("users").whereField("email", isEqualTo: emailToFollow).getDocuments(completion: {
            (querySnapshot, err) in
            if let err = err {
                print("Error getting user: \(err)")
                return
            }
            if(querySnapshot?.count != 1) {
                print("no user with email \(emailToFollow)")
                return
            }
            
            let data:Dictionary <String,Any> = querySnapshot!.documents[0].data()
            let followeeUid = data["uid"] as! String
            let followeeEmail = data["email"] as! String

            let document_id = "\(self.delegate.user!.uid)_\(followeeUid)"
            db.collection("followers").document(document_id).setData([
                "follower_uid": self.delegate.user!.uid,
                "followee_uid": followeeUid,
                "is_allowed": false,
                "follower_email": self.delegate.user!.email!,
                "followee_email": followeeEmail
            ]){ err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added")
                    self.updateFollowees()
                }
            }
        })
    }
}
