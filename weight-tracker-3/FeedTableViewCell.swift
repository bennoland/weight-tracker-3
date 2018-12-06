import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var buttonTapAction: (() -> ())!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populate(row: Dictionary<String,Any>) {
        emailButton.setTitle(row["owner_email"] as? String, for: UIControl.State.normal)
        
        let weight = row["weight"] as! Double
        weightLabel.text = String(weight)
        
        let date = row["date"] as! Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateLabel.text = dateFormatter.string(from: date)
    }
    
    @IBAction func emailButtonPressed(_ sender: Any) {
        buttonTapAction()
    }
}
