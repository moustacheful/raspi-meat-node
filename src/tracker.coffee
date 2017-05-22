Session = require('./session')
firebase = require('./firebase')

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
			index: data.index
			lastSince: Date.now()

		@ref = firebase.ref('status').push()
		@ref.set
			label: data.label
			index: data.index
			active: false
			since: Date.now()
			lastDuration: 0

		return

	setState: (isActive)->
		if @active != isActive
			# Update only on change
			@ref.update
				active: isActive
				since: Date.now()
				lastDuration: (Date.now() - @data.lastSince) / 10
			
		# if was not active and is now
		if isActive && !@active
			@active = true
			#@session = new Session(@data)

		# if was active and is not now
		if @active && !isActive
			@active = false
			#@session.end()

		@data.lastSince = Date.now() 