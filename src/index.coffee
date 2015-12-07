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

for tracker in trackers
	reader.watch(tracker.input)

reader.on 'value', (input)->
	tracker = _.find(trackers,{input:input.num})
	currentState = true
	if input.value < tracker.threshold
		currentState = false

	tracker.setState(currentState)

heartbeat = setInterval ->
	firebase.child('status').update
		heartbeat: Date.now()
,5000


process.on 'SIGINT', ->
	clearInterval(heartbeat)
	reader.close()
	process.exit()