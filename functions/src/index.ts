import * as v1 from 'firebase-functions/v1';
import * as v2 from 'firebase-functions/v2';
const admin = require('firebase-admin');
admin.initializeApp(v1.config().firebase);

export const helloWorld = v1.https.onRequest((request, response) => {
    console.log('hello!');
    response.send('please work')
})

exports.v1hello = v1.https.onCall(async (data, context) => {
    return `Successfully received: v1`;
});

exports.v2hello = v2.https.onCall((request) => {
    return `Successfully received: v2`;
});

exports.writeMessage = v1.https.onCall(async (data, context) => {
    // Grab the text parameter.
    const original = data.text;
    //Returns the text received
    return `Successfully received: ${original}`;
});

export const makeadmin = v2.https.onCall((request) => {
    const user = admin.auth.getUserByEmail(request.data.emailToElevate);
    return admin.auth.setCustomUserClaims(user.uid, {
        role: 'super-admin',
    }).then(() => {
        return `${request.data.emailToElevate}`;
    }
    ).catch((err: any) => {return err;});
})

export const addDefaultRole = v1.auth.user().onCreate((user) => {
    debugger;
    let uid = user.uid;

    return admin.auth().setCustomUserClaims(uid, {
        role: 'regular',
    }).then(() => {
        console.log(uid);
        return {
            message: `Success! ${user.email} is regulared`
        }
    }).catch((err: any) => {return err;})
});



// export const helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
