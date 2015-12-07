EventEmitter = require('events').EventEmitter
GPIO = require('onoff').Gpio
_ = require('lodash')

sampleSize = 50
module.exports = class AnalogReader	extends EventEmitter
	_watchHandle: null
	watched: []
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

	watch: (adcnum)->
		return false if ! (0 <= adcnum < 7)		
		@watched.push
			num:adcnum
			buffer: []
			value: @read(adcnum)

		@readWatched()

	readWatched: =>
		_.delay =>
			_.each @watched, (input)=>
				val = @read(input.num)
				input.buffer.push(val)
				if input.buffer.length >= sampleSize
					input.buffer.sort()
					input.value = input.buffer[ Math.round(sampleSize / 2) ]
					@emit('value',input)
					input.buffer = []

			@readWatched()
		, 10

	stopWatch: ->
		if _watchHandle
			clearInterval(_watchHandle)


	close: ->
		@mosipin.unexport()
		@misopin.unexport()
		@clockpin.unexport()
		@cspin.unexport()
		@stopWatch()
		console.log 'Destroying reader\r\n'
