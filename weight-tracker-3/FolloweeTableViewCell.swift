import UIKit

class FolloweeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var emailButton: UIButton!
    var buttonPressed: (() -> ())!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func populate(row: Dictionary<String,Any>) {
        let email = row["followee_email"] as! String
        emailButton.setTitle(email, for: UIControl.State.normal)
    }
    
    @IBAction func emailButtonPressed(_ sender: Any) {
        buttonPressed()
    }
}
