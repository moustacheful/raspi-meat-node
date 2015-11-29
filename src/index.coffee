require('dotenv').load({silent:true})
Tracker = require('./tracker')
AnalogReader = require('./reader')

SPICLK = 18
SPIMISO = 23
SPIMOSI = 24
SPICS = 25

reader = new AnalogReader(SPICLK,SPIMOSI,SPIMISO,SPICS)

trackers = [
		new Tracker
			input: 0
			id: 'b_1'
			label: 'Baño Hombres'
			threshold: 100
	,
		new Tracker
			input: 1
			id: 'b_2'
			label: 'Baño Mujeres'
			threshold: 100
]

main = ->
	for tracker in trackers
		currentInput = reader.read(tracker.input)

		currentValue = true
		if currentInput < tracker.threshold
			currentValue = false

		tracker.setState(currentValue)

setInterval main,300
