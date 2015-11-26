Session = require('./session')

module.exports = class Tracker
	active: false
	session: false
	constructor: (@data)-> return
	setState: (isActive)->
		if isActive && !@active
			@active = true
			@session = new Session(@data)

		if @active && !isActive
			@active = false
			@session.end()