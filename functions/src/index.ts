import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
admin.initializeApp();

export const helloWorld = functions.https.onRequest((request, response) => {
  console.log("hello!");
  response.send("please work");
});

exports.sayhello = functions.https.onCall(async (data, context) => {
  return "hello boi";
});

export const makeadmin = functions.https.onCall((request) => {
    // debugger;
    // const user = admin.auth.getUserByEmail(request.data.email);
    // return admin.auth.setCustomUserClaims(request.data.user.uid, {
    //     role: 'super-admin',
    // }).then(() => {
    //     return `<h1>${request.data.text}</h1>`;
    // }
    // );
  return "<h1>please</h1>";
});

export const addDefaultRole = functions.auth.user().onCreate((user) => {
//   debugger;
  const uid = user.uid;

  return admin.auth().setCustomUserClaims(uid, {
    role: "regular",
  }).then(() => {
    console.log(uid);
    return {
      message: `Success! ${user.email} is regulared`,
    };
  }).catch((err: any) => {
    return err;
  });
});


// export const helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
