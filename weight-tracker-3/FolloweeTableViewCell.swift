import UIKit

class FolloweeTableViewCell: UITableViewCell {
    @IBOutlet weak var emailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func populate(row: Dictionary<String,Any>) {
        let email = row["email"] as! String
        emailLabel.text = email
    }
}
