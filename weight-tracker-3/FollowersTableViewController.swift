import UIKit
import FirebaseAuth

class FollowersTableViewController: UITableViewController {
    var delegate: AppDelegate!
    var followers: [Dictionary<String,Any>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = UIApplication.shared.delegate as? AppDelegate
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("here")
        loadFollowers()
    }
    
    func loadFollowers() {
        
        let db = FirestoreDelegate.db()
        print((self.delegate.user?.uid)!)
        db.collection("followers")
            .whereField("followee_uid", isEqualTo: (self.delegate.user?.uid)!)
            .getDocuments(completion: {
                (querySnapshot, err) in
                if let err = err {
                    print("Error: \(err)")
                    return
                }
                
                for document in querySnapshot!.documents {
                    let data:Dictionary <String,Any> = document.data()
                    print(data)
                    self.followers.append([
                        "email": data["follower_email"] as! String,
                        "is_allowed": data["is_allowed"] as! Bool,
                        "follower_uid": data["follower_uid"] as! String
                        ])
                }
                
                self.tableView.reloadData()
            })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int {
            return followers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "followerCell",
                                                       for: indexPath) as? FollowerTableViewCell
            else {
                fatalError("dequeued cell was of wrong type")
        }
        
        let follower = self.followers[indexPath.row]
        cell.populate(row: follower)
        
        return cell
    }
}
