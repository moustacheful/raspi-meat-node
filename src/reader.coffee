GPIO = require('onoff').Gpio

module.exports = class AnalogReader	
	constructor: (clockpin,mosipin,misopin,cspin)->
		@clockpin = new GPIO(clockpin,'out')
		@mosipin = new GPIO(mosipin,'in')
		@misopin = new GPIO(misopin,'out')
		@cspin = new GPIO(cspin,'out')
		return

	read: (adcnum)->
		return if ! 0 < adcnum < 7

		@cspin.writeSync(true)

		@clockpin.writeSync(false)
		@cspin.writeSync(false)

		commandout = adcnum
		commandout += 0x18
		commandout <<= 3
		for i in [0..4]
			if commandout & 0x80
				mosipin.writeSync(true)
			else
				mosipin.writeSync(false)

			commandout <<= 1
			@clockpin.writeSync(true)
			@clockpin.writeSync(false)

		adcout = 0

		for i in [0..11]
			@clockpin.writeSync(true)
			@clockpin.writeSync(false)
			adcout <<= 1
			if @misopin.readSync()
				adcout += 0x1

		@cspin.writeSync(true)

		adcout >>= 1
		return adcout