import UIKit
import FirebaseAuth
import Firebase

class NewEntryViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var weightEntry: UITextField!
    var delegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = UIApplication.shared.delegate as? AppDelegate
    }
    
    func saveToFirebase(weight:Double, date:Date) {
        let db = FirestoreDelegate.db()
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let doc_name = delegate.user!.uid + "_" + df.string(from: date)
        db.collection("weighins").document(doc_name).setData([
            "date": date,
            "weight": weight,
            "user_uid": delegate.user!.uid
        ]){ err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added")
            }
        }
    }
    
    @IBAction func savePressed(_ sender: Any) {
        let weight = Double(weightEntry.text!)
        let date = datePicker.date
        
        self.saveToFirebase(weight: weight!, date: date)
        
        // switch to log tab
        self.tabBarController?.selectedIndex=1
    }
}
