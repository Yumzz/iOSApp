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

exports.reviewAdd = functions.https.onRequest((req, resp) => {
  cors(req, resp, () => {
    let body = req.body.Body;
    let dishID = req.body.DishID;
    let username = req.body.Username;
    let restID = req.body.RestID;
    let starRating = req.body.StarRating;
    let userID = req.body.UserID;

    admin
      .firestore()
      .collection("DishReview")
      .add({
        Body: body,
        dishID: dishID,
        restID: restID,
        username: username,
        StarRating: Number(starRating),
        userid: userID,
      })
      .then(function () {
        console.log("Successfully added Review");
        resp.status(200).send("Added Review");
        return;
      })
      .catch(function (error) {
        console.log("Error adding Review:", error);
        resp
          .status(500)
          .send(
            `Not added. Something wrong with user ${Username} and dish ${DishID}`
          );
      });
  });
});

exports.dishAdd = functions.https.onRequest((req, resp) => {
  cors(req, resp, () => {
    //post info into feedback collection

    let d = req.body.Description;
    let n = req.body.Name;
    let p = req.body.Price;
    let r = req.body.Restaurant;
    let t = req.body.Type;

    admin
      .firestore()
      .collection("Dish")
      .add({
        Name: n,
        Description: d,
        Price: p,
        Type: t,
        Restaurant: r,
      })
      .then(function () {
        console.log("Successfully added Dish");
        resp.status(200).send("Added Dish");
        return;
      })
      .catch(function (error) {
        console.log("Error adding Dish:", error);
        resp
          .status(500)
          .send(
            `Not added. Something wrong with dish ${Name} and restaurant ${Restaurant}`
          );
      });
  });
});

exports.getRestaurant = functions.https.onRequest((req, resp) => {
  cors(req, resp, () => {
    let i = req.body.id;
    admin
      .firestore()
      .collection("Restaurant")
      .doc(i)
      .get()
      .then(function (doc) {
        if (doc.exists) {
          console.log("doc data: ", doc.data());
          resp.status(200).send(doc.data());
        } else {
          console.log("doc not there");
          resp.status(500).send(`No doc for this rest exists`);
        }
        return;
      })
      .catch(function (error) {
        console.log("error", error);
        resp.status(500).send(error);
      });
  });
});

exports.getDishes = functions.https.onRequest((req, resp) => {
  cors(req, resp, () => {
    let restaurandID = req.body.id;

    admin
      .firestore()
      .collection("Dish")
      .where("Restaurant", "==", restaurandID)
      .get()
      .then(querySnapshot => {
        resp.status(200).send(querySnapshot.docs);
        return;
      })
      .catch(function (error) {
        console.log("error", error);
        resp.status(500).send(error);
      })
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
