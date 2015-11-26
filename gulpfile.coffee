
gulp         = require("gulp")
coffee       = require("gulp-coffee")
watch        = require("gulp-watch")
notify       = require("gulp-notify")
plumber      = require("gulp-plumber")
nodemon      = require('gulp-nodemon')

files =
	dist: './dist'
	server:
		watch:        './src/**/*.coffee'
		dest:         './app'

gulp.task "serve", ['build:server'], ->
	nodemon
		script: 'app'
		ext: 'js'
		delay: 100
		watch: [
			'app/index.js'
		]
	gulp.watch files.server.watch,   [ "build:server" ]
	return

gulp.task "debug", ['build:server'], -> 	
	nodemon
		script: 'app'
		ext: 'js'
		delay: 100
		nodeArgs: ['--debug']
		watch: [
			'app/index.js'
		]
	return

gulp.task 'build:server', ->
	gulp.src([
		files.server.watch,
	])
		.pipe plumber(
			errorHandler: (error)->
				notify.onError('Server compilation error: <%= error.message %>')
				console.log('\n' + error.stack)
		)
		.pipe(coffee({
			bare: 'true'
		}))
		.pipe(gulp.dest(files.server.dest))
	return