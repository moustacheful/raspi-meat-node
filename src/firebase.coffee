Firebase = require 'firebase'

firebase = Firebase.initializeApp
  apiKey: process.env.FIREBASE_API_KEY,
  authDomain: "#{process.env.FIREBASE_SLUG}.firebaseapp.com"
  databaseURL: "https://#{process.env.FIREBASE_SLUG}.firebaseio.com"
  projectId: process.env.FIREBASE_SLUG
  storageBucket: "#{process.env.FIREBASE_SLUG}.appspot.com"
  messagingSenderId: process.env.FIREBASE_SENDER_ID

module.exports = firebase.database()
