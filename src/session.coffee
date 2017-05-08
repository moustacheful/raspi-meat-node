moment = require('moment')
_ = require('lodash')
firebase = require('./firebase')
sessionRef = firebase.ref('session')

timestampFormat = 'YYYY-MM-D HH:mm:ss'

debug = if process.env.DEBUG then true else false

module.exports = class Session
	isActive: true
	endTime: undefined
	constructor: (@meta)-> 
		@startTime = Date.now()
		@firebaseRef = sessionRef.push
			startTime: @startTime
			id: @meta.id
			label: @meta.label

		if debug
			console.log 'Session started:'
			console.log JSON.stringify(@meta)
			console.log 'At:', moment(@startTime).format(timestampFormat)
			console.log '-------------------------------------------------------'

		return
	end: ->
		@isActive = false
		@endTime = Date.now()
		@duration = @endTime - @startTime

		if @duration < 5000
			@firebaseRef.remove()
		else
			@firebaseRef.update
				endTime: @endTime
				duration: @duration

		if debug
			console.log 'Session ended:'
			console.log JSON.stringify(@meta)
			console.log 'From  : ',moment(@startTime).format(timestampFormat)
			console.log 'Until : ', moment(@endTime).format(timestampFormat)
			console.log 'Lasted: ', @duration / 1000, 'seconds'
			console.log '-------------------------------------------------------'
