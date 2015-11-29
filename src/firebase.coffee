Firebase = require 'firebase'
firebase = new Firebase(process.env.FIREBASE_URI)
module.exports = firebase