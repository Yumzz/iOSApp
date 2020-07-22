const functions = require("firebase-functions");

const admin = require("firebase-admin");

// const nodemailer = require("nodemailer");
const cors = require("cors")({ origin: true });
admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

// let transporter = nodemailer.createTransport({
//   service: "gmail",
//   auth: {
//     user: "yumzzapp@gmail.com",
//     pass: "YumzzApp123!",
//   },
// });

// exports.sendEmail = functions.https.onRequest((req, resp) => {
//   cors(req, resp, () => {
//     // getting dest email by query string
//     const dest = req.query.dest;
//     const mailOptions = {
//       from: "Yumzz <yumzzapp@gmail.com>", // Something like: Jane Doe <janedoe@gmail.com>
//       to: dest,
//       subject: "I'M A PICKLE!!!", // email subject
//       html: `<p style="font-size: 16px;">Pickle Riiiiiiiiiiiiiiiick!!</p>
//             <br />
//             <img src="https://images.prod.meredith.com/product/fc8754735c8a9b4aebb786278e7265a5/1538025388228/l/rick-and-morty-pickle-rick-sticker" />
//         `, // email content in HTML
//     };

//     // returning result
//     return transporter.sendMail(mailOptions, (erro, info) => {
//       if (erro) {
//         return res.send(erro.toString());
//       }
//       return res.send("Sended");
//     });
//   });
// });

exports.feedback = functions.https.onRequest((req, resp) => {
  cors(req, resp, () => {
    //post info into feedback collection

    let e = req.body.email;
    let n = req.body.name;
    let m = req.body.message;
    let t = req.body.Type;

    admin
      .firestore()
      .collection("Feedback")
      .add({
        Name: n,
        Email: e,
        Message: m,
        Type: t,
      })
      .then(function () {
        console.log("Successfully added Feedback");
        resp.status(200).send("Added Feedback");
        return;
      })
      .catch(function (error) {
        console.log("Error adding feedback:", error);
        resp
          .status(500)
          .send(
            `Not added. Something wrong with user ${name} and email ${email}`
          );
      });
  });
});

// exports.signOut = functions.https.onRequest((req, resp) => {
//   cors(req, resp, () => {
//     firebase
//       .auth()
//       .signOut()
//       .then((prom) => {
//         if (prom !== nil) {
//           Console.log("Signed Out: ");
//           return prom;
//         }
//         return prom;
//       })
//       .catch((error) => {
//         if (error === Error) {
//           Console.log("Failed ");
//         }
//       });
//   });
// });
