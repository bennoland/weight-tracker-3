import UIKit
import FirebaseAuth
import Firebase

class FeedTableViewController: UITableViewController {
    var delegate: AppDelegate!
    var feedEntries: [Dictionary<String,Any>] = []
    var selectedUid: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = UIApplication.shared.delegate as? AppDelegate
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadFeed()
    }
    
    func loadFeed() {
        
        let db = FirestoreDelegate.db()
        db.collection("feed_weighins")
            .whereField("uid", isEqualTo: (self.delegate.user?.uid)!)
            .getDocuments(completion: {
                (querySnapshot, err) in
                if let err = err {
                    print("Error: \(err)")
                    return
                }
                self.feedEntries.removeAll()
                for document in querySnapshot!.documents {
                    let data:Dictionary <String,Any> = document.data()
                    //                    print("\(document.documentID) => \(data)")
                    
                    let timestamp = data["date"] as! Timestamp
                    self.feedEntries.append([
                        "owner_email": data["owner_email"] as! String,
                        "owner_uid": data["owner_uid"] as! String,
                        "weight": data["weight"] as Any,
                        "date": timestamp.dateValue()
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
            return feedEntries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell",
                                                       for: indexPath) as? FeedTableViewCell
            else {
                fatalError("dequeued cell was of wrong type")
        }
        
        let entry = self.feedEntries[indexPath.row]
        cell.populate(row: entry)
        cell.buttonTapAction = {
            self.selectedUid = entry["owner_uid"] as? String
            self.performSegue(withIdentifier: "feedToUserProfile", sender: self)
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "feedToUserProfile" {
            if let uidToShow = selectedUid  {
                print("here \(uidToShow)")
                let destinationViewController = segue.destination as! UserProfileViewController
                destinationViewController.uid = uidToShow
            } else {
                print("this should not happen")
            }
        }
    }
}
