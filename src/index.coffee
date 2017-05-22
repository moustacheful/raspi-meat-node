require('dotenv').load({silent:true})

_ = require('lodash')
AnalogReader = require('analog-reader')
Tracker = require('./tracker')
firebase = require('./firebase')

SPICLK = 18
SPIMISO = 23
SPIMOSI = 24
SPICS = 25

mockCounters = {0: 0, 1: 0, 2: 0, 3: 0}
mockFn = unless process.env.USE_MOCK then undefined else (input)->
	mockCounters[input]++
	noise = (Math.random() * 50) - 25 
	return (((Math.round(mockCounters[input]/5000) + input) % 2) * 170 ) + noise

reader = new AnalogReader(SPICLK, SPIMOSI, SPIMISO, SPICS, mockFn)
trackers = [
		new Tracker
			input: 0
			index: 0
			label: 'Baño 1'
			threshold: 150
	,
		new Tracker
			input: 1
			index: 1
			label: 'Baño 2'
			threshold: 150
	,
		new Tracker
			input: 2
			index: 2
			label: 'Baño 3'
			threshold: 150
	,
		new Tracker
			input: 3
			index: 3
			label: 'Baño 4'
			threshold: 150
]

for tracker in trackers
	reader.watch(tracker.input)

reader.start()

reader.on 'value', (input)->
	tracker = _.find(trackers,{input:input.num})
	currentState = true
	
	if input.value < tracker.threshold
		currentState = false

	tracker.setState(currentState)

heartbeat = setInterval ->
	firebase.ref('health').update
		heartbeat: Date.now()
, 5000


process.on 'SIGINT', ->
	firebase.ref('status').remove()
	clearInterval(heartbeat)
	reader.close()
	process.exit()