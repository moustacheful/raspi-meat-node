GPIO = require('onoff').Gpio

module.exports = class AnalogReader	
	constructor: (clockpin,mosipin,misopin,cspin)->
		@mosipin = new GPIO(mosipin,'out')
		@misopin = new GPIO(misopin,'in')
		@clockpin = new GPIO(clockpin,'out')
		@cspin = new GPIO(cspin,'out')
		return

	read: (adcnum)->
		return -1 if ! (0 <= adcnum < 7)

		@cspin.writeSync(1)

		@clockpin.writeSync(0)
		@cspin.writeSync(0)

		commandout = adcnum
		commandout |= 0x18
		commandout <<= 3

		for i in [0..4]
			if commandout & 0x80
				@mosipin.writeSync(1)
			else
				@mosipin.writeSync(0)

			commandout <<= 1
			@clockpin.writeSync(1)
			@clockpin.writeSync(0)


		adcout = 0

		for i in [0..11]
			@clockpin.writeSync(1)
			@clockpin.writeSync(0)
			adcout <<= 1

			if @misopin.readSync()
				adcout |= 0x1

		@cspin.writeSync(1)
		adcout >>= 1
		return adcout

	close: ->
		@mosipin.unexport()
		@misopin.unexport()
		@clockpin.unexport()
		@cspin.unexport()
		console.log 'Destroying reader\r\n'
