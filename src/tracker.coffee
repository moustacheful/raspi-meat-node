Session = require('./session')
firebase = require('./firebase')

statusRef = firebase.child('status')

module.exports = class Tracker
	active: false
	session: false
	value: false
	input: 0
	constructor: (data)-> 
		@threshold = data.threshold
		@input = data.input
		@data = 
			label: data.label
			id: data.id

		return
	setState: (isActive)->
		if @active != isActive
			# Update only on change
			statusRef.child(@data.id).set(isActive)

		# if was not active and is now
		if isActive && !@active
			@active = true
			@session = new Session(@data)

		# if was active and is not now
		if @active && !isActive
			@active = false
			@session.end()