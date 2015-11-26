require('dotenv').load({silent:true})

AnalogReader = require('./reader')

SPICLK = 18
SPIMISO = 23
SPIMOSI = 24
SPICS = 25

reader = new AnalogReader(SPICLK,SPIMISO,SPIMOSI,SPICS)

trackers = [
		new Tracker
			input: 0
			id: 'b_1'
			label: 'Baño Hombres'
			threshold: 70
			value: false
	,
		new Tracker
			input: 1
			id: 'b_2'
			label: 'Baño Mujeres'
			threshold: 70
			value: false
]

main = ->
	for tracker in trackers
		currentInput = reader.read(tracker.data.input)
		
		currentValue = true
		if currentInput < tracker.threshold
			currentValue = false

		if currentValue != tracker.value
			#NOTIFY FIREBASE
			console.log tracker.label, 'changed', currentValue

		tracker.value = currentValue
				
setInterval main,1000