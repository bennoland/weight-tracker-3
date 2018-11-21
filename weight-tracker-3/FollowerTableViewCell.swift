import UIKit

class FollowerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var approveButton: UIButton!
    var followerUId: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func populate(row: Dictionary<String,Any>) {
        let email = row["email"] as! String
        emailLabel.text = email
        approveButton.isHidden = row["is_allowed"] as! Bool
        self.followerUId = row["follower_uid"] as! String
    }
    
    @IBAction func approveButtonPressed(_ sender: Any) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let db = FirestoreDelegate.db()
        let doc_id = "\(followerUId)_\((delegate.user?.uid)!)"
        
        print("setting allowed \(doc_id)")
        db.collection("followers").document(doc_id).updateData(["is_allowed":true]){
            err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document updated")
            }
        }
    }
}
