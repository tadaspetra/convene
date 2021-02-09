// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
const functions = require('firebase-functions');

// The Firebase Admin SDK to access Cloud Firestore.
const admin = require('firebase-admin');
admin.initializeApp();
const database = admin.firestore();

exports.createUser = functions.auth.user().onCreate(user => {
    const { displayName, email, photoURL, uid } = user;

    const newUser = {
        name: displayName,
        photoURL,
        email,
    };

    functions.logger.info("Creating User", newUser);
    return database
        .collection('users')
        .doc(uid)
        .set(newUser);
});

// executes at every hour mark
exports.checkForBookTransition = functions.pubsub.schedule('0 * * * *').onRun(async (context) => {
    const query = await database.collection("clubs")
        .where("currentBookDue", '<=', admin.firestore.Timestamp.now())
        .get();
    query.forEach(async eachClub => {
        var currentIndex = eachClub.data()["indexPickingBook"];
        var totalSelectors = eachClub.data()["selectors"].length;
        var nextIndex;

        // find who the next selector is
        if (currentIndex >= (totalSelectors - 1)) {
            nextIndex = 0;
        } else {
            nextIndex = currentIndex + 1;
        }
        console.log(eachClub.data()["nextBookId"] === undefined);
        console.log(eachClub.data()["nextBookDue"]);

        if ((eachClub.data()["nextBookId"] !== undefined)) {
            console.log("IF:" + eachClub.id);
            await database.doc('clubs/' + eachClub.id).update({
                "currentBookDue": eachClub.data()["nextBookDue"],
                "currentBookId": eachClub.data()["nextBookId"],
                "nextBookId": admin.firestore.FieldValue.delete(),
                "nextBookDue": admin.firestore.FieldValue.delete(),
                "indexPickingBook": nextIndex,
                "currentReaders": admin.firestore.FieldValue.delete(),
            })
        } else {
            //next book hasn't been picked
            console.log("ELSE:" + eachClub.id);
            await database.doc('clubs/' + eachClub.id).update({
                "currentBookDue": admin.firestore.FieldValue.delete(),
                "currentBookId": admin.firestore.FieldValue.delete(),
                "nextBookId": admin.firestore.FieldValue.delete(),
                "nextBookDue": admin.firestore.FieldValue.delete(),
                "indexPickingBook": nextIndex, // skip the person that was supposed to pick
                //TODO: remove that user from selectors, since he missed his pick
            })
        }
    })
});

// exports.onCreateNotification = functions.firestore.document("/notifications/{notificationDoc}").onCreate(async (notifSnapshot, context) => {
//     var tokens = notifSnapshot.data()['tokens'];
//     var bookName = notifSnapshot.data()['bookName'];
//     var author = notifSnapshot.data()['author'];

//     var title = `Next Book Announced`;
//     var body = `Next book is ${bookName} by ${author}`;

//     tokens.forEach(async eachToken => {
//         const message = {
//             notification: { title: title, body: body },
//             token: eachToken,
//             data: { click_action: 'FLUTTER_NOTIFICATION_CLICK' },
//         }

//         admin.messaging().send(message).then(response => {
//             return console.log("Notification Succesful");
//         }).catch(error => {
//             return console.log("Error: " + error);
//         });
//     });
// });


// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
