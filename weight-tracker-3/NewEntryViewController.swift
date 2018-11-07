import UIKit
import FirebaseAuth
import Firebase

class NewEntryViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var weightEntry: UITextField!
    var handle: AuthStateDidChangeListenerHandle?
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            print("auth state changed in ViewController")
            self.user = user
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    func saveToFirebase(weight:Double, date:Date) {
        let db = Firestore.firestore()
        
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let doc_name = user!.uid + "_" + df.string(from: date)
        db.collection("weighins").document(doc_name).setData([
            "date":date,
            "weight":weight,
            "user_uid": user!.uid
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
        
        print("got \(weight) at \(date)")
        self.saveToFirebase(weight: weight!, date: date)
        
        // switch to log tab
        self.tabBarController?.selectedIndex=1
    }
}
