moment = require('moment')
timestampFormat = 'YYYY-MM-D HH:mm:ss'
module.exports = class Session
	isActive: true
	endTime: undefined
	constructor: (@meta)-> 
		@startTime = Date.now()

		console.log 'Session started:'
		console.log JSON.stringify(@meta)
		console.log 'At:', moment(@startTime).format(timestampFormat)
		console.log '-------------------------------------------------------'
		return
	end: ->
		@isActive = false
		@endTime = Date.now()
		@duration = @endTime - @startTime
		console.log 'Session ended:'
		console.log JSON.stringify(@meta)
		console.log 'From  : ',moment(@startTime).format(timestampFormat)
		console.log 'Until : ', moment(@endTime).format(timestampFormat)
		console.log 'Lasted: ', @duration / 1000, 'seconds'
		console.log '-------------------------------------------------------'
