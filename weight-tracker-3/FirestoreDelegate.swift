/*
 Firestore utilities
 */
import Firebase

class FirestoreDelegate {
    
    static func db() -> Firestore {
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        return db
    }
}
