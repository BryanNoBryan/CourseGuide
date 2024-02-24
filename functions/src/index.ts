/*eslint-disable*/


import * as v1 from 'firebase-functions/v1';
import * as v2 from 'firebase-functions/v2';
import * as admin from 'firebase-admin';
import { getAuth } from 'firebase-admin/auth';
admin.initializeApp();

//v1.config().firebase
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

exports.writeMessagev2 = v2.https.onCall((request) => {
    // Grab the text parameter.
    const original = request.data.text;
    //Returns the text received
    return `Successfully received: ${original}`;
});

exports.getuid = v2.https.onCall((request) => {
    return request.auth?.uid;
});

exports.returnemail = v2.https.onCall((request) => {
    return getAuth().getUserByEmail('h@gmail.com').then((user: any) => {return user.email});
});

exports.makeadmin = v2.https.onCall((request) => {
    //apparently this one line is bad
    
    // return user.uid;
    //WORKKKKKKKKKS
    // return request.auth?.uid;
    // return request.data.emailToElevate;
    //

    // return request.auth?.uid;
    debugger;
    return getAuth().getUserByEmail(request.auth!.uid).then((user: any) => {return user.email});
    //idea try the bottom code first
    // return admin.auth.setCustomUserClaims(user.uid, {
    //     role: 'super-admin',
    // }).then(() => {
    //     return `${request.data.emailToElevate}`;
    // }
    // ).catch((err: any) => {return err;});
    }
);


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
