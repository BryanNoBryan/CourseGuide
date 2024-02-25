/*eslint-disable*/


import * as v1 from 'firebase-functions/v1';
import * as v2 from 'firebase-functions/v2';
import * as admin from 'firebase-admin';
import { getAuth } from 'firebase-admin/auth';
import { error } from 'firebase-functions/logger';
admin.initializeApp();

exports.makeAdmin = v2.https.onCall(async (request) => {

    const reqUID = request.auth?.uid;
    if (reqUID == null) {
        error('not logged in');
    }

    const reqClaims = (await getAuth().getUser(reqUID!)).customClaims;
    if (reqClaims == null) {
        error('how did claims get deleted!?');
    }

    // return `${(await getAuth().getUser(reqUID!)).email},,,${reqClaims!['role']}`;

    if (!(reqClaims!['role'] === 'super-admin')) {
        error('insufficent permissions!!');
    }

    const user = await getAuth().getUserByEmail(request.data.emailToElevate);
    
    if (!["super-admin", "admin", "regular"].includes(request.data.role)) {
        error('not a valid role');
    }
    const perms = request.data.role;

    getAuth()
        .setCustomUserClaims(user.uid, { role: perms })
        .then(() => {
            return `magic ${user.email} is changed to ${perms}`;
        }).catch((e) => {
            error('setting claims error', e);
        });
});


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





// //v1.config().firebase
// export const helloWorld = v1.https.onRequest((request, response) => {
//     console.log('hello!');
//     response.send('please work')
// })

// exports.v1hello = v1.https.onCall(async (data, context) => {
//     return `Successfully received: v1`;
// });

// exports.v2hello = v2.https.onCall((request) => {
//     return `Successfully received: v2`;
// });

// exports.writeMessage = v1.https.onCall(async (data, context) => {
//     // Grab the text parameter.
//     const original = data.text;
//     //Returns the text received
//     return `Successfully received: ${original}`;
// });

// exports.writeMessagev2 = v2.https.onCall((request) => {
//     // Grab the text parameter.
//     const original = request.data.text;
//     //Returns the text received
//     return `Successfully received: ${original}`;
// });

// exports.getuid = v2.https.onCall((request) => {
//     return request.auth?.uid;
// });

// exports.returnemail = v2.https.onCall((request) => {
//     return getAuth().getUserByEmail('h@gmail.com').then((user: any) => {return user.email});
// });

// export const helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
