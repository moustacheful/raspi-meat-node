require('dotenv').load({silent:true})
_ = require('lodash')
Tracker = require('./tracker')
AnalogReader = require('./reader')
firebase = require('./firebase')

SPICLK = 18
SPIMISO = 23
SPIMOSI = 24
SPICS = 25

reader = new AnalogReader(SPICLK,SPIMOSI,SPIMISO,SPICS)

trackers = [
		new Tracker
			input: 1
			id: 'b_1'
			label: 'Baño Hombres'
			threshold: 150
	,
		new Tracker
			input: 0
			id: 'b_2'
			label: 'Baño Mujeres'
			threshold: 150
]

main = ->
	#_.times process.stdout.getWindowSize()[1], -> console.log('\r\n')
	for tracker in trackers
		currentInput = reader.read(tracker.input)
		currentValue = true
		#console.log currentInput, tracker.data.label
		if currentInput < tracker.threshold
		#if Math.random()*1000 < tracker.threshold
			currentValue = false

		tracker.setState(currentValue)

mainLoop = setInterval main, 300

heartbeat = setInterval ->
	firebase.child('status').update
		heartbeat: Date.now()
,10000


process.on 'SIGINT', ->
	clearInterval(mainLoop)
	clearInterval(heartbeat)
	reader.close()
	process.exit()