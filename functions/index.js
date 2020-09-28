// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
const functions = require('firebase-functions');

// The Firebase Admin SDK to access Cloud Firestore.
const admin = require('firebase-admin');
admin.initializeApp();

exports.createUser = functions.auth.user().onCreate(user => {
    const { displayName, email, photoURL, uid } = user;

    const newUser = {
        name: displayName,
        photoURL,
        email,
    };

    functions.logger.info("Creating User", newUser);
    return admin.firestore()
        .collection('users')
        .doc(uid)
        .set(newUser);
});

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
