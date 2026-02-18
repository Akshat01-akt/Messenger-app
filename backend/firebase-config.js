const admin = require('firebase-admin');
const dotenv = require('dotenv');

dotenv.config();

const initializeFirebase = () => {
    try {
        // You need to generate a Service Account Key from Firebase Console
        // Project Settings -> Service Accounts -> Generate New Private Key
        // Save it as 'service-account.json' in this backend folder

        // const serviceAccount = require('./service-account.json');

        // admin.initializeApp({
        //   credential: admin.credential.cert(serviceAccount)
        // });

        // For now, we'll just log that it needs setup
        console.log("Firebase Admin SDK needs setup with service-account.json");

    } catch (error) {
        console.error("Error initializing Firebase Admin:", error);
    }
};

module.exports = { initializeFirebase, admin };
