// firebase deploy --only functions

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

const settings = {timestampsInSnapshots: true};
admin.firestore().settings(settings);

function formatDate(date) {
  var month = '' + (date.getMonth() + 1);
  var day = '' + date.getDate();
  var year = date.getFullYear();

  if (month.length < 2) month = '0' + month;
  if (day.length < 2) day = '0' + day;

  return [year, month, day].join('-');
}

exports.syncWeighinToFeed = functions.firestore.document('weighins/{uid_date}')
  .onWrite((change, context) => {
    const doc = change.after.exists ? change.after.data() : change.before.data();
    const isDelete = !change.after.exists;
    const ownerUid = doc["user_uid"];
    const date = doc["date"].toDate();
    
    const queryPromise = admin.firestore().collection("followers")
    .where("followee_uid", "==", ownerUid).get()
    .then(snapshot => {
      snapshot.forEach(followerDoc => {
        const followerUid = followerDoc.data().follower_uid;
        const docId = followerUid + "_" + ownerUid + "_" + formatDate(date);
        const feedRef = admin.firestore().collection("feed_weighins").doc(docId);
        if(isDelete) {
          feedRef.delete();
        } else {
          feedRef.set({
            uid: followerUid,
            owner_uid: ownerUid,
            weight: doc["weight"],
            date: doc["date"]
          });
        }
      });
    })
    .catch(err => {
           console.log('Error getting documents', err);
    });
    return queryPromise;
});