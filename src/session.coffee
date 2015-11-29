moment = require('moment')
_ = require('lodash')
firebase = require('./firebase')
sessionRef = firebase.child('session')

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
		@firebaseRef = sessionRef.push
			startTime: @startTime
			id: @meta.id
			label: @meta.label

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

		@firebaseRef.update
			endTime: @endTime
			duration: @duration
