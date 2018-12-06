import UIKit
import FirebaseAuth
import Firebase

class LogViewController: UITableViewController {
    
    var weighins: [Dictionary<String,Any>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadWeighins()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int {
            return weighins.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "weighinCell",
                                                       for: indexPath) as? WeighinTableViewCell
            else {
                fatalError("dequeued cell was of wrong type")
        }
        
        let weighin = self.weighins[indexPath.row]
        cell.populate(row: weighin)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let rowToDelete = self.weighins[indexPath.row]
            
            let date = rowToDelete["date"] as! Date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let docKey = delegate.user!.uid + "_" + dateFormatter.string(from: date)
            let db = FirestoreDelegate.db()
            db.collection("weighins").document(docKey).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                }
            }
            
            self.weighins.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func loadWeighins()
    {
        let db = FirestoreDelegate.db()
        let delegate = UIApplication.shared.delegate as! AppDelegate
        self.weighins = []
        db.collection("weighins").whereField("user_uid", isEqualTo: delegate.user!.uid).getDocuments(completion: {
            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data:Dictionary <String,Any> = document.data()
//                    print("\(document.documentID) => \(data)")
                    let timestamp = data["date"] as! Timestamp
                    let row = [
                        "weight": data["weight"] as Any,
                        "date": timestamp.dateValue()
                    ]
                    self.weighins.append(row)
                }
            }
            self.tableView.reloadData()
        })
    }
}
