import UIKit
import FirebaseAuth

class FolloweesTableViewController: UITableViewController {
    var delegate: AppDelegate!
    var followees: [Dictionary<String,Any>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = UIApplication.shared.delegate as? AppDelegate
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadFollowees()
    }
    
    func loadFollowees() {

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
                
                for document in querySnapshot!.documents {
                    let data:Dictionary <String,Any> = document.data()
                    //                    print("\(document.documentID) => \(data)")

                    self.followees.append(["email": data["followee_email"] as! String])
                }
                
                self.tableView.reloadData()
            })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int {
            return followees.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "followeeCell",
                                                       for: indexPath) as? FolloweeTableViewCell
            else {
                fatalError("dequeued cell was of wrong type")
        }
        
        let followee = self.followees[indexPath.row]
        cell.populate(row: followee)
        
        return cell
    }
}
