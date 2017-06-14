require('dotenv').load({silent:true})
five = require('johnny-five')
_ = require('lodash')
Tracker = require('./tracker')
firebase = require('./firebase')

trackers = [
	new Tracker
		input: 0
		index: 0
		label: 'Baño 1'
		threshold: 10

	new Tracker
		input: 1
		index: 1
		label: 'Baño 2'
		threshold: 20
]

board = new five.Board();
board.on 'ready', ->
	_.each trackers, (tracker) ->
		sensor = new five.Sensor('A' + tracker.input)
		sensor.on 'change', ->
			console.log tracker.input, @pin, @scaleTo(0, 1023)
			currentState = true

			if @scaleTo(0, 100) < tracker.threshold
				currentState = false

			tracker.setState(currentState)

heartbeat = setInterval ->
	firebase.ref('health').update
		heartbeat: Date.now()
, 5000

onExit = ->
	firebase.ref('status').remove()
	clearInterval(heartbeat)
	process.exit()

process.once 'SIGINT', onExit
process.once 'SIGTERM', onExit
process.once 'SIGUSR2', onExit